const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true }, // Trim to remove unnecessary spaces
    description: { type: String, default: "", trim: true }, // Ensures no undefined value
    completed: { type: Boolean, default: false },
    dueAt: { type: Date, required: true }, // Ensure tasks have a due date
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true, index: true }, // 🔥 Renamed to userId
  },
  { timestamps: true }
);

module.exports = mongoose.model("Task", taskSchema);
