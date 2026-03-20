const express = require("express");
const router = express.Router();

const { authenticate } = require("../middleware/authMiddleware");
const {
  createBooking,
  getAvailability,
} = require("../controllers/bookingController");

// ---------------- CREATE BOOKING ----------------
router.post("/", authenticate, createBooking);

// ---------------- GET AVAILABILITY (COURT-BASED) ----------------
router.get("/availability/:courtId", authenticate, getAvailability);

// ---------------- GET MY BOOKINGS ----------------
router.get("/my", authenticate, async (req, res) => {
  try {
    const Booking = require("../models/Booking");
    const userId = req.user.id;

    const bookings = await Booking.findAll({
      where: { user_id: userId },
      order: [["date", "DESC"]],
    });

    return res.json(bookings);
  } catch (error) {
    return res.status(500).json({
      error: "Failed to fetch bookings",
    });
  }
});

// ---------------- CANCEL BOOKING ----------------
router.patch("/:id/cancel", authenticate, async (req, res) => {
  try {
    const Booking = require("../models/Booking");

    const bookingId = req.params.id;
    const userId = req.user.id;
    const userRole = req.user.role;

    const booking = await Booking.findByPk(bookingId);

    if (!booking) {
      return res.status(404).json({ error: "Booking not found" });
    }

    if (booking.user_id !== userId && userRole !== "ADMIN") {
      return res.status(403).json({ error: "Not authorized" });
    }

    if (booking.status !== "CONFIRMED") {
      return res.status(400).json({
        error: "Only confirmed bookings can be cancelled",
      });
    }

    booking.status = "CANCELLED";
    await booking.save();

    return res.json({
      message: "Booking cancelled successfully",
      booking,
    });
  } catch (error) {
    return res.status(500).json({
      error: "Failed to cancel booking",
    });
  }
});

module.exports = router;
