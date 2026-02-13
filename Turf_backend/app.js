const express = require("express");
const cors = require("cors");

const healthRoutes = require("./routes/health.routes");
const userRoutes = require("./routes/users.routes");
const turfRoutes = require("./routes/turfs.routes");
const authRoutes = require("./routes/authRoutes");
const bookingRoutes = require("./routes/bookingRoutes");


const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Backend is running");
});


app.use("/api", healthRoutes);
app.use("/api", userRoutes);
app.use("/api", turfRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/bookings", bookingRoutes);
  

module.exports = app;
