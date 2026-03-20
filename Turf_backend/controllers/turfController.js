// controllers/turfController.js

const { Turf } = require("../models");
const { generateAvailability } = require("../services/availabilityService");

exports.getAvailability = async (req, res) => {
  try {
    const { id } = req.params;
    const { date } = req.query;

    if (!date) {
      return res.status(400).json({ message: "Date is required" });
    }

    const turf = await Turf.findByPk(id);

    if (!turf) {
      return res.status(404).json({ message: "Turf not found" });
    }

    const slots = await generateAvailability(turf, date);

    return res.status(200).json({
      turf_id: turf.id,
      date,
      slots,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Server error" });
  }
};
