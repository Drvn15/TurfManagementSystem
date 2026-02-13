const app = require("./app");
const sequelize = require("./models/db");

// Load all models FIRST
const User = require("./models/User");
const Turf = require("./models/Turf");
const Booking = require("./models/Booking");

// ---- Associations ----
User.hasMany(Booking, {
  foreignKey: "user_id",
  onDelete: "CASCADE",
});

Turf.hasMany(Booking, {
  foreignKey: "turf_id",
  onDelete: "CASCADE",
});

Booking.belongsTo(User, {
  foreignKey: "user_id",
});

Booking.belongsTo(Turf, {
  foreignKey: "turf_id",
});

// ---- Server Boot ----
const PORT = process.env.PORT || 5000;

async function startServer() {
  try {
    await sequelize.authenticate();
    console.log("Database connection established");

    // In development only.
    // DO NOT use force: true in production.
    await sequelize.sync({ alter: true });

    console.log("Models synchronized");

    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error("Server startup failed:", error);
    process.exit(1);
  }
}

startServer();
