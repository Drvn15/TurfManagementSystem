// utils/time.js

/**
 * Convert "HH:MM" or "HH:MM:SS" → integer minutes
 */
function timeStringToMinutes(timeStr) {
  if (typeof timeStr !== "string") {
    throw new Error("Invalid time format. Expected string");
  }

  const parts = timeStr.split(":");

  // Accept HH:MM or HH:MM:SS
  if (parts.length < 2 || parts.length > 3) {
    throw new Error("Invalid time format. Expected HH:MM or HH:MM:SS");
  }

  const hours = Number(parts[0]);
  const minutes = Number(parts[1]);

  if (
    isNaN(hours) ||
    isNaN(minutes) ||
    hours < 0 ||
    hours > 23 ||
    minutes < 0 ||
    minutes > 59
  ) {
    throw new Error("Invalid time value");
  }

  return hours * 60 + minutes;
}

/**
 * Convert minutes → "HH:MM"
 */
function minutesToTimeString(minutes) {
  if (typeof minutes !== "number" || minutes < 0 || minutes >= 1440) {
    throw new Error("Minutes out of range");
  }

  const h = Math.floor(minutes / 60)
    .toString()
    .padStart(2, "0");

  const m = (minutes % 60)
    .toString()
    .padStart(2, "0");

  return `${h}:${m}`;
}

/**
 * Normalize time input (CRITICAL)
 * Handles:
 * - integer (DB)
 * - "HH:MM"
 * - "HH:MM:SS"
 */
function normalizeTime(value) {
  if (value === null || value === undefined || value === "") {
    throw new Error("Invalid or missing time value");
  }

  if (typeof value === "number") {
    return value;
  }

  if (typeof value === "string") {
    return timeStringToMinutes(value);
  }

  throw new Error("Unsupported time format");
}

/**
 * Validate slot alignment (30 or 60 mins grid)
 */
function isValidSlotAlignment(start, end, slotSize) {
  return (
    start % slotSize === 0 &&
    end % slotSize === 0 &&
    end > start
  );
}

/**
 * Duration in minutes
 */
function getDuration(start, end) {
  return end - start;
}

module.exports = {
  timeStringToMinutes,
  minutesToTimeString,
  normalizeTime,        // (important)
  isValidSlotAlignment,
  getDuration,
};