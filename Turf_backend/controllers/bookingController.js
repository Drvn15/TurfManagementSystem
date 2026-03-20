const { Op } = require("sequelize");
const sequelize = require("../models/db");
const Booking = require("../models/Booking");
const Court = require("../models/Court");

const createBooking = async (req, res) => {
  const transaction = await sequelize.transaction();

  try {
    const userId = req.user?.id;
    const { court_id, date, start_time, end_time } = req.body;

    // ---------------- BASIC VALIDATION ----------------
    if (!userId || !court_id || !date || !start_time || !end_time) {
      await transaction.rollback();
      return res.status(400).json({
        message: "Missing required fields",
      });
    }

    // ---------------- VALIDATE COURT EXISTS ----------------
    const court = await Court.findByPk(court_id, { transaction });

    if (!court) {
      await transaction.rollback();
      return res.status(404).json({
        message: "Court not found",
      });
    }

    // ---------------- TIME VALIDATION ----------------
    const start = new Date(`1970-01-01T${start_time}`);
    const end = new Date(`1970-01-01T${end_time}`);

    const durationMinutes = (end - start) / (1000 * 60);

    if (durationMinutes <= 0) {
      await transaction.rollback();
      return res.status(400).json({
        message: "Invalid time range",
      });
    }

    // ---------------- SLOT TYPE VALIDATION ----------------
    if (court.slot_type === "hourly" && durationMinutes !== 60) {
      await transaction.rollback();
      return res.status(400).json({
        message: "This court allows only 1-hour bookings",
      });
    }

    if (court.slot_type === "half-hourly" && durationMinutes !== 30) {
      await transaction.rollback();
      return res.status(400).json({
        message: "This court allows only 30-minute bookings",
      });
    }

    // ---------------- SESSION WINDOW VALIDATION ----------------
    const morningStart = new Date(`1970-01-01T${court.morning_start}`);
    const morningEnd = new Date(`1970-01-01T${court.morning_end}`);
    const eveningStart = new Date(`1970-01-01T${court.evening_start}`);
    const eveningEnd = new Date(`1970-01-01T${court.evening_end}`);

    const withinMorning =
      start >= morningStart && end <= morningEnd;

    const withinEvening =
      start >= eveningStart && end <= eveningEnd;

    if (!withinMorning && !withinEvening) {
      await transaction.rollback();
      return res.status(400).json({
        message: "Booking outside allowed session time",
      });
    }

    // ---------------- CONFLICT DETECTION (COURT-SCOPED) ----------------
    const conflict = await Booking.findOne({
      where: {
        court_id,
        date,
        status: { [Op.ne]: "CANCELLED" },
        start_time: { [Op.lt]: end_time },
        end_time: { [Op.gt]: start_time },
      },
      transaction,
      lock: transaction.LOCK.UPDATE,
    });

    if (conflict) {
      await transaction.rollback();
      return res.status(409).json({
        message: "Slot already booked",
      });
    }

    // ---------------- CREATE BOOKING ----------------
    const booking = await Booking.create(
      {
        user_id: userId,
        court_id,
        date,
        start_time,
        end_time,
      },
      { transaction }
    );

    await transaction.commit();

    return res.status(201).json({
      message: "Booking created successfully",
      booking,
    });

  } catch (error) {
    await transaction.rollback();

    return res.status(500).json({
      message: "Booking failed",
      error: error.message,
    });
  }
};

const getAvailability = async (req, res) => {
  try {
    const { courtId } = req.params;
    const { date } = req.query;

    if (!courtId || !date) {
      return res.status(400).json({
        message: "courtId and date are required",
      });
    }

    const court = await Court.findByPk(courtId);

    if (!court) {
      return res.status(404).json({
        message: "Court not found",
      });
    }

    const bookings = await Booking.findAll({
      where: {
        court_id: courtId,
        date,
        status: { [Op.ne]: "CANCELLED" },
      },
    });

    const interval = court.slot_type === "hourly" ? 60 : 30;

    const bookedRanges = bookings.map(b => ({
      start: b.start_time,
      end: b.end_time,
    }));

    const generateSlots = (startTime, endTime, sessionLabel) => {
      const slots = [];

      let current = new Date(`1970-01-01T${startTime}`);
      const sessionEnd = new Date(`1970-01-01T${endTime}`);

      while (current < sessionEnd) {
        const slotStart = new Date(current);
        const slotEnd = new Date(current.getTime() + interval * 60000);

        if (slotEnd > sessionEnd) break;

        const formattedStart = slotStart.toTimeString().slice(0, 5);
        const formattedEnd = slotEnd.toTimeString().slice(0, 5);

        const conflict = bookedRanges.some(b =>
          b.start < formattedEnd &&
          b.end > formattedStart
        );

        slots.push({
          start_time: formattedStart,
          end_time: formattedEnd,
          session: sessionLabel,
          available: !conflict,
        });

        current = slotEnd;
      }

      return slots;
    };

    const morningSlots = generateSlots(
      court.morning_start,
      court.morning_end,
      "morning"
    );

    const eveningSlots = generateSlots(
      court.evening_start,
      court.evening_end,
      "evening"
    );

    const allSlots = [...morningSlots, ...eveningSlots]
      .sort((a, b) => a.start_time.localeCompare(b.start_time));

    return res.json({
      court_id: Number(courtId),
      date,
      slot_type: court.slot_type,
      slots: allSlots,
    });

  } catch (error) {
    return res.status(500).json({
      message: "Failed to fetch availability",
      error: error.message,
    });
  }
};


module.exports = {
  createBooking,
  getAvailability,
};
