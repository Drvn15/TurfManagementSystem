const CourtSession = require("../models/courtSession");
const Court = require("../models/Court");

function minutesToDbTime(minutes) {
  const hh = String(Math.floor(minutes / 60)).padStart(2, "0");
  const mm = String(minutes % 60).padStart(2, "0");
  return `${hh}:${mm}:00`;
}

function validateSessionTime(session) {
  if (!session) return;

  if (session.start >= session.end) {
    throw new Error("start_time must be less than end_time");
  }

  if (session.start < 0 || session.end > 1440) {
    throw new Error("Session must be within 0–1440 minutes");
  }
}

function validateNoOverlap(morning, evening) {
  if (!morning || !evening) return;

  if (morning.end > evening.start) {
    throw new Error("Morning and Evening sessions cannot overlap");
  }
}

async function upsertSessions(courtId, { morning, evening }) {
  validateSessionTime(morning);
  validateSessionTime(evening);
  validateNoOverlap(morning, evening);

  const court = await Court.findByPk(courtId);
  if (!court) {
    throw new Error("Court not found");
  }

  const operations = [];

  if (morning) {
    operations.push(
      CourtSession.upsert({
        court_id: courtId,
        session_type: "MORNING",
        start_time: morning.start,
        end_time: morning.end
      })
    );
  }

  if (evening) {
    operations.push(
      CourtSession.upsert({
        court_id: courtId,
        session_type: "EVENING",
        start_time: evening.start,
        end_time: evening.end
      })
    );
  }

  // Keep court table in sync because booking logic reads these fields.
  const courtPatch = {};
  if (morning) {
    courtPatch.morning_start = minutesToDbTime(morning.start);
    courtPatch.morning_end = minutesToDbTime(morning.end);
  }
  if (evening) {
    courtPatch.evening_start = minutesToDbTime(evening.start);
    courtPatch.evening_end = minutesToDbTime(evening.end);
  }

  if (Object.keys(courtPatch).length > 0) {
    operations.push(court.update(courtPatch));
  }

  await Promise.all(operations);
}

async function getSessions(courtId) {
  return await CourtSession.findAll({
    where: { court_id: courtId }
  });
}

module.exports = {
  upsertSessions,
  getSessions
};
