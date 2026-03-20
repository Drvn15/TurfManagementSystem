const { DataTypes } = require("sequelize");
const sequelize = require("./db");

const Turf = sequelize.define(
  "Turf",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    location: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    image_url: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  {
    tableName: "Turf",
    timestamps: false,
  }
);

module.exports = Turf;
