const express = require("express");
const router = express.Router();
const sessionController = require("../controllers/sessionController");
const { authenticate, adminOnly } = require("../middleware/authMiddleware");

router.put("/courts/:id/sessions", authenticate, adminOnly, sessionController.updateSessions);
router.get("/courts/:id/sessions", authenticate, sessionController.getSessions);

module.exports = router;
