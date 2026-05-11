const express = require("express");
const router = express.Router();

const Turf = require("../models/Turf");
const { authenticate, adminOnly } = require("../middleware/authMiddleware");

// ==================== PUBLIC ENDPOINTS ====================

// GET ALL TURFS (PUBLIC) - For user discovery
router.get("/turfs", async (req, res) => {
  try {
    const turfs = await Turf.findAll();
    res.json(turfs);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch turfs" });
  }
});

// ==================== ADMIN ENDPOINTS ====================

// GET MY TURFS (ADMIN ONLY) - Owner's turfs only
router.get("/turfs/my", authenticate, adminOnly, async (req, res) => {
  try {
    const userId = Number(req.user.id);
    const turfs = await Turf.findAll({
      where: { owner_id: userId },
    });
    res.json(turfs);
  } catch (error) {
    console.error("Fetch My Turfs Error:", error);
    res.status(500).json({ error: "Failed to fetch your turfs" });
  }
});

// CREATE TURF (ADMIN ONLY) - Set owner_id to current user
router.post("/turfs", authenticate, adminOnly, async (req, res) => {
  try {
    const { name, location, price_per_hour, image_url } = req.body;
    const adminId = Number(req.user.id);
    const price = Number(price_per_hour ?? 0);

    if (!name || !location || price <= 0) {
      return res.status(400).json({ error: "Missing or invalid required fields" });
    }

    const turf = await Turf.create({
      owner_id: adminId,
      name,
      location,
      price_per_hour: price,
      image_url: image_url || null,
    });

    res.status(201).json(turf);
  } catch (error) {
    console.error("Create Turf Error:", error);
    res.status(500).json({ error: "Failed to create turf" });
  }
});

// UPDATE TURF (ADMIN ONLY - OWNERSHIP CHECK)
router.put("/turfs/:id", authenticate, adminOnly, async (req, res) => {
  try {
    const turf = await Turf.findByPk(req.params.id);

    if (!turf) {
      return res.status(404).json({ error: "Turf not found" });
    }

    // OWNERSHIP CHECK: Admin can only edit their own turfs
    const adminId = Number(req.user.id);
    if (turf.owner_id !== adminId) {
      return res.status(403).json({ error: "Not authorized to edit this turf" });
    }

    const { name, location, image_url, price_per_hour } = req.body;
    const price = price_per_hour != null ? Number(price_per_hour) : turf.price_per_hour;

    await turf.update({
      name: name ?? turf.name,
      location: location ?? turf.location,
      image_url: image_url ?? turf.image_url,
      price_per_hour: price,
    });

    res.json({
      message: "Turf updated successfully",
      turf,
    });
  } catch (error) {
    console.error("Update Turf Error:", error);
    res.status(500).json({ error: "Failed to update turf" });
  }
});

// DELETE TURF (ADMIN ONLY - OWNERSHIP CHECK)
router.delete("/turfs/:id", authenticate, adminOnly, async (req, res) => {
  try {
    const turf = await Turf.findByPk(req.params.id);

    if (!turf) {
      return res.status(404).json({ error: "Turf not found" });
    }

    // OWNERSHIP CHECK: Admin can only delete their own turfs
    const adminId = Number(req.user.id);
    if (turf.owner_id !== adminId) {
      return res.status(403).json({ error: "Not authorized to delete this turf" });
    }

    await turf.destroy();

    res.json({ message: "Turf deleted successfully" });
  } catch (error) {
    console.error("Delete Turf Error:", error);
    res.status(500).json({ error: "Failed to delete turf" });
  }
});

module.exports = router;
