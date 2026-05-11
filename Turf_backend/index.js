require("dotenv").config();
const app = require("./app");
const sequelize = require("./models/db");

// Load all models FIRST
const User = require("./models/User");
const Turf = require("./models/Turf");
const Booking = require("./models/Booking");
const Court = require("./models/Court");

// ---- Associations ----
User.hasMany(Booking, {
  foreignKey: "user_id",
  onDelete: "CASCADE",
});

Court.hasMany(Booking, {
  foreignKey: "court_id",
  onDelete: "CASCADE",
});

Booking.belongsTo(User, {
  foreignKey: "user_id",
});

Booking.belongsTo(Court, {
  foreignKey: "court_id",
});

// ---- Server Boot ----
const PORT = process.env.PORT || 5000;

async function startServer() {
  try {
    await sequelize.authenticate();
    console.log("Database connection established");

    // In development only.
    // Only sync the Turf model here to fix the missing owner_id column
    // without altering unrelated existing tables like court_sessions.
    await Turf.sync({ alter: true });
    console.log("Turf model synchronized");

    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error("Server startup failed:", error);
    process.exit(1);
  }
}

startServer();
