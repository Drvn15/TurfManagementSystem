const { Op } = require("sequelize");
const sequelize = require("../models/db");
const Booking = require("../models/Booking");
const Court = require("../models/Court");
const Sport = require("../models/Sports");
const Turf = require("../models/Turf");

const {
  timeStringToMinutes,
  minutesToTimeString,
} = require("../utils/time");

/**
 * NORMALIZER
 */
const normalizeTime = (value) => {
  if (typeof value === "number") return value;
  return timeStringToMinutes(value);
};

/**
 * CREATE BOOKING
 */
const createBooking = async (req, res) => {
  const transaction = await sequelize.transaction();

  try {
    console.log("➡️ REQUEST RECEIVED");

    const userId = req.user?.id;
    const { court_id, date, start_time, end_time } = req.body;

    console.log("INPUT:", { userId, court_id, date, start_time, end_time });

    if (!userId || !court_id || !date || start_time === undefined || end_time === undefined) {
      console.log("❌ Missing fields");
      await transaction.rollback();
      return res.status(400).json({ message: "Missing required fields" });
    }

    const court = await Court.findByPk(court_id, { transaction });

    if (!court) {
      console.log("❌ Court not found");
      await transaction.rollback();
      return res.status(404).json({ message: "Court not found" });
    }

    const start = typeof start_time === "number"
      ? start_time
      : timeStringToMinutes(start_time);

    const end = typeof end_time === "number"
      ? end_time
      : timeStringToMinutes(end_time);

    console.log("TIME NORMALIZED:", { start, end });

    if (end <= start) {
      console.log("❌ Invalid time range");
      await transaction.rollback();
      return res.status(400).json({
        error: "INVALID_TIME_RANGE",
        message: "Booking must end after it starts within the same day"
      });
    }

    const duration = end - start;

    const slotSize = court.slot_type === "hourly" ? 60 : 30;

    const morningStart = normalizeTime(court.morning_start);
    const morningEnd = normalizeTime(court.morning_end);
    const eveningStart = normalizeTime(court.evening_start);
    const eveningEnd = normalizeTime(court.evening_end);

    console.log("SESSION DATA:", {
      morningStart,
      morningEnd,
      eveningStart,
      eveningEnd
    });

    let sessionStart = null;

    if (start >= morningStart && end <= morningEnd) {
      sessionStart = morningStart;
      console.log("✔ Using MORNING session");
    } else if (start >= eveningStart && end <= eveningEnd) {
      sessionStart = eveningStart;
      console.log("✔ Using EVENING session");
    } else {
      console.log("❌ Outside session");
      await transaction.rollback();
      return res.status(400).json({
        error: "OUTSIDE_SESSION",
        message: "Booking outside allowed session time"
      });
    }

    // 🔥 THIS WILL NOW ALWAYS PRINT IF SESSION PASSES
    console.log("SLOT DEBUG:", {
      start,
      end,
      duration,
      slotSize,
      slotType: court.slot_type,
      sessionStart,
      morningStart,
      rawStart: start_time,
      rawEnd: end_time
    });

    if (
      (start - sessionStart) % slotSize !== 0 ||
      duration % slotSize !== 0
    ) {
      console.log("❌ Slot alignment failed");
      await transaction.rollback();
      return res.status(400).json({
        error: "INVALID_SLOT_ALIGNMENT",
        message: "Invalid slot alignment"
      });
    }

    console.log("✔ Slot validation passed");

    let booking;

    try {
      booking = await Booking.create(
        {
          user_id: userId,
          court_id,
          date,
          start_time: start,
          end_time: end,
          status: "CONFIRMED",
        },
        { transaction }
      );
    } catch (error) {
      console.log("❌ DB conflict");

      if (
        error.name === "SequelizeDatabaseError" ||
        error.name === "SequelizeUniqueConstraintError"
      ) {
        await transaction.rollback();
        return res.status(409).json({
          error: "SLOT_CONFLICT",
          message: "Slot already booked"
        });
      }

      throw error;
    }

    await transaction.commit();

    console.log("✅ BOOKING SUCCESS");

    return res.status(201).json({
      message: "Booking created successfully",
      booking,
    });

  } catch (error) {
    await transaction.rollback();

    console.log("🔥 SERVER ERROR:", error.message);

    return res.status(500).json({
      message: "Booking failed",
      error: error.message,
    });
  }
};

/**
 * CANCEL BOOKING
 */
const cancelBooking = async (req, res) => {
  const transaction = await sequelize.transaction();

  try {
    const userId = req.user?.id;
    const { bookingId } = req.params;

    if (!userId || !bookingId) {
      await transaction.rollback();
      return res.status(400).json({ message: "Missing required fields" });
    }

    const booking = await Booking.findByPk(bookingId, { transaction });

    if (!booking) {
      await transaction.rollback();
      return res.status(404).json({ message: "Booking not found" });
    }

    if (booking.user_id !== userId) {
      await transaction.rollback();
      return res.status(403).json({ message: "Unauthorized" });
    }

    if (booking.status === "CANCELLED") {
      await transaction.rollback();
      return res.status(400).json({ message: "Already cancelled" });
    }

    booking.status = "CANCELLED";
    await booking.save({ transaction });

    await transaction.commit();

    return res.status(200).json({
      message: "Booking cancelled successfully",
    });

  } catch (error) {
    await transaction.rollback();
    return res.status(500).json({
      message: "Cancellation failed",
      error: error.message,
    });
  }
};

/**
 * GET AVAILABILITY
 */
const getAvailability = async (req, res) => {
  try {
    const { courtId } = req.params;
    const { date } = req.query;

    if (!courtId || !date) {
      return res.status(400).json({ message: "courtId and date required" });
    }

    const court = await Court.findByPk(courtId);

    if (!court) {
      return res.status(404).json({ message: "Court not found" });
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

    const generateSlots = (startVal, endVal, label) => {
      const start = normalizeTime(startVal);
      const end = normalizeTime(endVal);

      const slots = [];

      for (let t = start; t < end; t += interval) {
        const slotEnd = t + interval;
        if (slotEnd > end) break;

        const conflict = bookedRanges.some(
          b => !(slotEnd <= b.start || t >= b.end)
        );

        slots.push({
          start_time: minutesToTimeString(t),
          end_time: minutesToTimeString(slotEnd),
          session: label,
          available: !conflict,
        });
      }

      return slots;
    };

    const slots = [
      ...generateSlots(court.morning_start, court.morning_end, "morning"),
      ...generateSlots(court.evening_start, court.evening_end, "evening"),
    ];

    return res.json({
      court_id: Number(courtId),
      date,
      slot_type: court.slot_type,
      slots,
    });

  } catch (error) {
    return res.status(500).json({
      message: "Failed to fetch availability",
      error: error.message,
    });
  }
};

/**
 * GET MY BOOKINGS
 */
const getMyBookings = async (req, res) => {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const bookings = await Booking.findAll({
      where: { user_id: userId },
      order: [
        ["date", "DESC"],
        ["start_time", "ASC"],
      ],
    });

    const payload = [];

    for (const booking of bookings) {
      const court = await Court.findByPk(booking.court_id);
      let turfName = court?.name || "Court";

      if (court?.sport_id) {
        const sport = await Sport.findByPk(court.sport_id);
        if (sport?.turf_id) {
          const turf = await Turf.findByPk(sport.turf_id);
          if (turf?.name) {
            turfName = turf.name;
          }
        }
      }

      const startMinutes =
        typeof booking.start_time === "number"
          ? booking.start_time
          : timeStringToMinutes(String(booking.start_time));

      const endMinutes =
        typeof booking.end_time === "number"
          ? booking.end_time
          : timeStringToMinutes(String(booking.end_time));

      payload.push({
        id: booking.id,
        turf_name: turfName,
        date: booking.date,
        start_time: minutesToTimeString(startMinutes),
        end_time: minutesToTimeString(endMinutes),
        status: booking.status,
      });
    }

    return res.status(200).json(payload);
  } catch (error) {
    return res.status(500).json({
      message: "Failed to fetch user bookings",
      error: error.message,
    });
  }
};

module.exports = {
  createBooking,
  cancelBooking,
  getAvailability,
  getMyBookings,
};
