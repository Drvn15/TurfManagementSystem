const express = require("express");
const router = express.Router();

const Sport = require("../models/Sports"); // must match filename exactly
const Turf = require("../models/Turf");
const { authenticate, adminOnly } = require("../middleware/authMiddleware");

// ---------------- CREATE SPORT ----------------
router.post("/", authenticate, adminOnly, async (req, res) => {
  try {
    const { turf_id, name } = req.body;

    if (!turf_id || !name) {
      return res.status(400).json({ error: "turf_id and name are required" });
    }

    const turf = await Turf.findByPk(turf_id);
    if (!turf) {
      return res.status(404).json({ error: "Turf not found" });
    }

    const sport = await Sport.create({ turf_id, name });

    res.status(201).json(sport);
  } catch (error) {
    res.status(500).json({ error: "Failed to create sport" });
  }
});

// ---------------- GET SPORTS BY TURF ----------------
router.get("/:turfId", async (req, res) => {
  try {
    const sports = await Sport.findAll({
      where: { turf_id: req.params.turfId },
    });

    res.json(sports);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch sports" });
  }
});

// ---------------- UPDATE SPORT ----------------
router.put("/:id", authenticate, adminOnly, async (req, res) => {
  try {
    const sport = await Sport.findByPk(req.params.id);

    if (!sport) {
      return res.status(404).json({ error: "Sport not found" });
    }

    const { name } = req.body;

    await sport.update({
      name: name ?? sport.name,
    });

    res.json({ message: "Sport updated", sport });
  } catch (error) {
    res.status(500).json({ error: "Failed to update sport" });
  }
});

// ---------------- DELETE SPORT ----------------
router.delete("/:id", authenticate, adminOnly, async (req, res) => {
  try {
    const sport = await Sport.findByPk(req.params.id);

    if (!sport) {
      return res.status(404).json({ error: "Sport not found" });
    }

    await sport.destroy();

    res.json({ message: "Sport deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete sport" });
  }
});

module.exports = router;
