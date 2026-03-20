const express = require("express");
const router = express.Router();

const Court = require("../models/Court");
const Sport = require("../models/Sports");
const { authenticate, adminOnly } = require("../middleware/authMiddleware");

// ---------------- CREATE COURT ----------------
router.post("/", authenticate, adminOnly, async (req, res) => {
  try {
    const {
      sport_id,
      name,
      slot_type,
      price,
      morning_start,
      morning_end,
      evening_start,
      evening_end,
    } = req.body;

    if (
      !sport_id ||
      !name ||
      !slot_type ||
      !price ||
      !morning_start ||
      !morning_end ||
      !evening_start ||
      !evening_end
    ) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const sport = await Sport.findByPk(sport_id);
    if (!sport) {
      return res.status(404).json({ error: "Sport not found" });
    }

    const court = await Court.create({
      sport_id,
      name,
      slot_type,
      price,
      morning_start,
      morning_end,
      evening_start,
      evening_end,
    });

    res.status(201).json(court);
  } catch (error) {
    res.status(500).json({ error: "Failed to create court" });
  }
});

// ---------------- GET COURTS BY SPORT ----------------
router.get("/:sportId", async (req, res) => {
  try {
    const courts = await Court.findAll({
      where: { sport_id: req.params.sportId },
    });

    res.json(courts);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch courts" });
  }
});

// ---------------- UPDATE COURT ----------------
router.put("/:id", authenticate, adminOnly, async (req, res) => {
  try {
    const court = await Court.findByPk(req.params.id);

    if (!court) {
      return res.status(404).json({ error: "Court not found" });
    }

    await court.update(req.body);

    res.json({ message: "Court updated", court });
  } catch (error) {
    res.status(500).json({ error: "Failed to update court" });
  }
});

// ---------------- DELETE COURT ----------------
router.delete("/:id", authenticate, adminOnly, async (req, res) => {
  try {
    const court = await Court.findByPk(req.params.id);

    if (!court) {
      return res.status(404).json({ error: "Court not found" });
    }

    await court.destroy();

    res.json({ message: "Court deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete court" });
  }
});

module.exports = router;
