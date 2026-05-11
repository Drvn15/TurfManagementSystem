const sequelize = require("./db");
const { DataTypes } = require("sequelize");

const Booking = sequelize.define(
  "Booking",
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    court_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    date: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },

    start_time: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    end_time: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    status: {
      type: DataTypes.ENUM("CONFIRMED", "CANCELLED"),
      defaultValue: "CONFIRMED",
    },

    payment_status: {
      type: DataTypes.ENUM("PENDING", "PAID"),
      defaultValue: "PENDING",
    },
  },
  {
    freezeTableName: true,
    indexes: [
      {
        fields: ["court_id", "date"],
      },
    ],
  }
);

module.exports = Booking;
