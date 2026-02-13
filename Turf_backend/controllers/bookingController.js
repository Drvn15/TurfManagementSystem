const { Op } = require("sequelize");
const sequelize = require("../models/db");
const Booking = require("../models/Booking");
const Turf = require("../models/Turf");

const createBooking = async (req, res) => {
  const transaction = await sequelize.transaction();

  try {
    const userId = req.user?.id;
    const { turf_id, date, start_time, end_time } = req.body;

    // Basic validation
    if (!userId || !turf_id || !date || !start_time || !end_time) {
      await transaction.rollback();
      return res.status(400).json({
        message: "Missing required fields",
      });
    }

    // Validate turf exists (inside transaction)
    const turf = await Turf.findByPk(turf_id, { transaction });

    if (!turf) {
      await transaction.rollback();
      return res.status(404).json({
        message: "Turf not found",
      });
    }

    // Overlap detection
    const conflict = await Booking.findOne({
      where: {
        turf_id,
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

    const booking = await Booking.create(
      {
        user_id: userId,
        turf_id,
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

module.exports = {
  createBooking,
};
