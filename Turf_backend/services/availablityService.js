// services/availabilityService.js

const { Booking } = require("../models");
const { Op } = require("sequelize");

function timeToMinutes(time) {
  const [hours, minutes] = time.split(":").map(Number);
  return hours * 60 + minutes;
}

function minutesToTime(minutes) {
  const h = String(Math.floor(minutes / 60)).padStart(2, "0");
  const m = String(minutes % 60).padStart(2, "0");
  return `${h}:${m}`;
}

async function generateAvailability(turf, date) {
  const interval = turf.slot_type === "HOURLY" ? 60 : 30;

  const opening = timeToMinutes(turf.opening_time);
  const closing = timeToMinutes(turf.closing_time);

  const bookings = await Booking.findAll({
    where: {
      turf_id: turf.id,
      date,
      status: "CONFIRMED",
    },
  });

  const slots = [];

  for (let start = opening; start < closing; start += interval) {
    const end = start + interval;

    const startTime = minutesToTime(start);
    const endTime = minutesToTime(end);

    const isBooked = bookings.some((booking) => {
      return (
        timeToMinutes(booking.start_time) < end &&
        timeToMinutes(booking.end_time) > start
      );
    });

    slots.push({
      start_time: startTime,
      end_time: endTime,
      available: !isBooked,
    });
  }

  return slots;
}

module.exports = { generateAvailability };
