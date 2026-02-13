function generateSlots(opening, closing, slotType) {
  const slots = [];

  const interval = slotType === "HOURLY" ? 60 : 30;

  let current = new Date(`1970-01-01T${opening}`);
  const end = new Date(`1970-01-01T${closing}`);

  while (current < end) {
    const slotStart = new Date(current);
    current.setMinutes(current.getMinutes() + interval);

    if (current > end) break;

    const slotEnd = new Date(current);

    slots.push({
      start_time: slotStart.toTimeString().slice(0, 8),
      end_time: slotEnd.toTimeString().slice(0, 8),
      label: `${slotStart.toTimeString().slice(0, 5)}-${slotEnd
        .toTimeString()
        .slice(0, 5)}`,
    });
  }

  return slots;
}

module.exports = { generateSlots };
