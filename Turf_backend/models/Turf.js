const { DataTypes } = require("sequelize");
const sequelize = require("./db");

const Turf = sequelize.define("Turf", {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  location: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  price_per_hour: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  opening_time: {
    type: DataTypes.TIME,
    allowNull: false,
  },

  closing_time: {
    type: DataTypes.TIME,
    allowNull: false,
  },

  slot_type: {
    type: DataTypes.ENUM("HOURLY", "HALF_HOURLY"),
    allowNull: false,
    defaultValue: "HOURLY",
  },

  image_url: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  is_active: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
}, {
  freezeTableName: true,   // prevents pluralization
  timestamps: true         // keeps createdAt & updatedAt
});

module.exports = Turf;
