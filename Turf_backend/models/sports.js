const { DataTypes } = require("sequelize");
const sequelize = require("./db");

const Sport = sequelize.define(
  "Sport",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    turf_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
  },
  {
    tableName: "sports",
    timestamps: false,
  }
);

module.exports = Sport;
