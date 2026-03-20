const { DataTypes } = require("sequelize");
const sequelize = require("./db");

const Court = sequelize.define(
  "Court",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    sport_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    slot_type: {
      type: DataTypes.ENUM("hourly", "half-hourly"),
      allowNull: false,
    },
    price: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
    },
    morning_start: {
      type: DataTypes.TIME,
      allowNull: false,
    },
    morning_end: {
      type: DataTypes.TIME,
      allowNull: false,
    },
    evening_start: {
      type: DataTypes.TIME,
      allowNull: false,
    },
    evening_end: {
      type: DataTypes.TIME,
      allowNull: false,
    },
  },
  {
    tableName: "courts",
    timestamps: false,
  }
);

module.exports = Court;
