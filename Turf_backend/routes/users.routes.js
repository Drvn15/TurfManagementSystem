const express = require("express");
const router = express.Router();
const User = require("../models/User");

// CREATE USER
router.post("/users", async (req, res) => {
  try {
    const { name, phone } = req.body;

    const user = await User.create({ name, phone });

    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: "Failed to create user" });
  }
});

// GET ALL USERS
router.get("/users", async (req, res) => {
  try {
    const users = await User.findAll();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch users" });
  }
});

module.exports = router;
