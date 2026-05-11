const { DataTypes } = require("sequelize");
const sequelize = require("./db");

const CourtSession = sequelize.define("court_sessions", {
  court_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  session_type: {
    type: DataTypes.ENUM("MORNING", "EVENING"),
    allowNull: false
  },
  start_time: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  end_time: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  timestamps: true,
  createdAt: "created_at",
  updatedAt: "updated_at"
});

module.exports = CourtSession;