const express = require("express");
const Task = require("../models/Task");
const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

// 🟢 Create a new task
router.post("/", authMiddleware, async (req, res) => {
  try {
    const { title, description, dueAt } = req.body;

    if (!title || typeof title !== "string") {
      return res.status(400).json({ message: "Task title is required and must be a string." });
    }
    if (!dueAt || !Date.parse(dueAt)) {
      return res.status(400).json({ message: "Valid due date is required." });
    }

    const newTask = new Task({
      title,
      description: description || "",
      dueAt: new Date(dueAt),
      user: req.user.id,
    });

    await newTask.save();
    res.status(201).json(newTask);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// 🟢 Get all tasks for a user
router.get("/", authMiddleware, async (req, res) => {
  try {
    const tasks = await Task.find({ user: req.user.id }).sort({ dueAt: 1 });
    res.json(tasks);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// 🟢 Update a task
router.put("/:id", authMiddleware, async (req, res) => {
  try {
    const { title, description, completed, dueAt } = req.body;

    const updatedTask = await Task.findOneAndUpdate(
      { _id: req.params.id, user: req.user.id },
      {
        ...(title && { title }),
        ...(description && { description }),
        ...(completed !== undefined && { completed }),
        ...(dueAt && { dueAt: new Date(dueAt) }),
      },
      { new: true, runValidators: true }
    );

    if (!updatedTask) {
      return res.status(404).json({ message: "Task not found or unauthorized" });
    }

    res.json(updatedTask);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
