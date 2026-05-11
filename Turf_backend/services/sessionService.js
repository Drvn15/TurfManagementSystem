const { CourtSession } = require("../models");

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