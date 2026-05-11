// middleware/bookingValidation.js

const {
  timeStringToMinutes,
  isValidSlotAlignment,
  getDuration,
} = require("../utils/time");

const MAX_DURATION = 180; // 3 hours

module.exports = function validateBooking(req, res, next) {
  try {
    const { start_time, end_time, slot_size } = req.body;

    const start =
      typeof start_time === "number"
        ? start_time
        : timeStringToMinutes(start_time);
    const end =
      typeof end_time === "number"
        ? end_time
        : timeStringToMinutes(end_time);

    // Basic validation
    if (start >= end) {
      return res.status(400).json({ error: "Invalid time range" });
    }

    // Slot alignment check
    // Keep slot_size optional because controller validates alignment from court config.
    if (
      slot_size !== undefined &&
      slot_size !== null &&
      !isValidSlotAlignment(start, end, slot_size)
    ) {
      return res.status(400).json({
        error: "Invalid slot alignment",
      });
    }

    // Duration check
    const duration = getDuration(start, end);
    if (duration > MAX_DURATION) {
      return res.status(400).json({
        error: "Booking exceeds max duration (180 mins)",
      });
    }

    // Past-time validation (IMPORTANT)
    const today = new Date().toISOString().split("T")[0];
    const now = new Date();
    const currentMinutes = now.getHours() * 60 + now.getMinutes();

    if (req.body.date === today && start < currentMinutes) {
      return res.status(400).json({
        error: "Cannot book past time",
      });
    }

    // Attach normalized values
    req.body.start_time = start;
    req.body.end_time = end;

    next();
  } catch (err) {
    return res.status(400).json({
      error: err.message,
    });
  }
};
