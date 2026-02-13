const { Sequelize } = require("sequelize");

const sequelize = new Sequelize(
  "turf_booking_db",   // database name
  "postgres",          // username
  "050709D15",     // password
  {
    host: "localhost",
    dialect: "postgres",
    logging: false,
  }
);

module.exports = sequelize;
