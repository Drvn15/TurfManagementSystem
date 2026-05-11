// routes/bookingRoutes.js

const express = require("express");
const router = express.Router();

// Controllers
const {
  createBooking,
  getAvailability,
  cancelBooking,
  getMyBookings,
} = require("../controllers/bookingController");

// Middleware
const validateBooking = require("../middleware/bookingValidation");
const {authenticate} = require("../middleware/authMiddleware");

/**
 * CREATE BOOKING
 * Flow:
 * Auth → Validation → Controller → DB
 */
router.post(
  "/book",
  authenticate,
  validateBooking,
  createBooking
);

// Compatibility route for frontend REST-style create
router.post(
  "/",
  authenticate,
  validateBooking,
  createBooking
);

/**
 * GET AVAILABILITY
 * Public (or protect if needed)
 */
router.get(
  "/availability/:courtId",
  getAvailability
);

/**
 * Cancellation
 * Checks Ownership
 */
router.patch(
  "/cancel/:bookingId",
  authenticate,
  cancelBooking
);

// Compatibility route for frontend REST-style cancel
router.patch(
  "/:bookingId/cancel",
  authenticate,
  cancelBooking
);

// My bookings (used by frontend)
router.get(
  "/my",
  authenticate,
  getMyBookings
);

module.exports = router;
