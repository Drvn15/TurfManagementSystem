const sessionService = require("../services/sessionService");

exports.updateSessions = async (req, res) => {
  try {
    const courtId = req.params.id;
    const { morning, evening } = req.body;

    await sessionService.upsertSessions(courtId, { morning, evening });

    res.status(200).json({
      message: "Sessions updated successfully"
    });
  } catch (err) {
    res.status(400).json({
      error: err.message
    });
  }
};

exports.getSessions = async (req, res) => {
  try {
    const courtId = req.params.id;

    const sessions = await sessionService.getSessions(courtId);

    res.status(200).json(sessions);
  } catch (err) {
    res.status(500).json({
      error: "Failed to fetch sessions"
    });
  }
};