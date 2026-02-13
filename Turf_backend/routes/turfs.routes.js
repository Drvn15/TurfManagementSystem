const express = require("express");
const router = express.Router();
const Turf = require("../models/Turf");
const { authenticate, adminOnly } = require("../middleware/authMiddleware");

// ---------------- GET ALL TURFS (PUBLIC) ----------------
router.get("/turfs", async (req, res) => {
  try {
    const turfs = await Turf.findAll();
    res.json(turfs);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch turfs" });
  }
});

// ---------------- CREATE TURF (ADMIN ONLY) ----------------
router.post("/turfs", authenticate, adminOnly, async (req, res) => {
  try {
    const { name, location, price_per_hour, image_url } = req.body;

    if (!name || !location || !price_per_hour) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const turf = await Turf.create({
      name,
      location,
      price_per_hour,
      image_url,
    });

    res.status(201).json(turf);
  } catch (error) {
    res.status(500).json({ error: "Failed to create turf" });
  }
});

// ---------------- DELETE TURF (ADMIN ONLY) ----------------
router.delete("/turfs/:id", authenticate, adminOnly, async (req, res) => {
  try {
    const turf = await Turf.findByPk(req.params.id);

    if (!turf) {
      return res.status(404).json({ error: "Turf not found" });
    }

    await turf.destroy();

    res.json({ message: "Turf deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to delete turf" });
  }
});

module.exports = router;
