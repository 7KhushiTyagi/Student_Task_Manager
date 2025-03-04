/**
 * Fetch all tasks for the logged-in user.
 * @param {Object} req - Express request object.
 * @param {Object} req.user - The logged-in user.
 * @param {string} req.user.id - The ID of the logged-in user.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>}
 */
exports.getTasks = async (req, res) => {};

/**
 * Create a new task for the logged-in user.
 * @param {Object} req - Express request object.
 * @param {Object} req.user - The logged-in user.
 * @param {string} req.user.id - The ID of the logged-in user.
 * @param {Object} req.body - The request body.
 * @param {string} req.body.title - The title of the task.
 * @param {string} [req.body.description] - The description of the task.
 * @param {string} req.body.dueAt - The due date of the task.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>}
 */
exports.createTask = async (req, res) => {};

/**
 * Update an existing task for the logged-in user.
 * @param {Object} req - Express request object.
 * @param {Object} req.user - The logged-in user.
 * @param {string} req.user.id - The ID of the logged-in user.
 * @param {Object} req.params - The request parameters.
 * @param {string} req.params.id - The ID of the task to update.
 * @param {Object} req.body - The request body.
 * @param {string} [req.body.title] - The new title of the task.
 * @param {string} [req.body.description] - The new description of the task.
 * @param {boolean} [req.body.completed] - The new completion status of the task.
 * @param {string} [req.body.dueAt] - The new due date of the task.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>}
 */
exports.updateTask = async (req, res) => {};

/**
 * Delete an existing task for the logged-in user.
 * @param {Object} req - Express request object.
 * @param {Object} req.user - The logged-in user.
 * @param {string} req.user.id - The ID of the logged-in user.
 * @param {Object} req.params - The request parameters.
 * @param {string} req.params.id - The ID of the task to delete.
 * @param {Object} res - Express response object.
 * @returns {Promise<void>}
 */
exports.deleteTask = async (req, res) => {};
const Task = require("../models/Task");

// ✅ Fetch all tasks for logged-in user
exports.getTasks = async (req, res) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const tasks = await Task.find({ userId: req.user.id }).sort({ dueAt: 1 }); // Sorting by due date
    res.json(tasks);
  } catch (error) {
    console.error("❌ Error fetching tasks:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ✅ Create a new task
exports.createTask = async (req, res) => {
  try {
    const { title, description, dueAt } = req.body;

    
    if (!title || typeof title !== "string") {
      return res.status(400).json({ message: "Task title is required and must be a string." });
    }
    if (!dueAt || isNaN(Date.parse(dueAt))) {
      return res.status(400).json({ message: "Valid due date is required." });
    }

    const newTask = new Task({
      userId: req.user.id,
      title,
      description,
      dueAt: new Date(dueAt),
    });

    await newTask.save();
    res.status(201).json(newTask);
  } catch (error) {
    console.error("❌ Error creating task:", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.updateTask = async (req, res) => {
  try {
    const { title, description, completed, dueAt } = req.body;

    
    const task = await Task.findOne({ _id: req.params.id, userId: req.user.id });
    if (!task) {
      return res.status(404).json({ message: "Task not found or unauthorized" });
    }

    
    if (title !== undefined) task.title = title;
    if (description !== undefined) task.description = description;
    if (completed !== undefined) task.completed = completed;
    if (dueAt !== undefined && !isNaN(Date.parse(dueAt))) task.dueAt = new Date(dueAt);

    await task.save();
    res.json(task);
  } catch (error) {
    console.error("❌ Error updating task:", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.deleteTask = async (req, res) => {
  try {
    const task = await Task.findOne({ _id: req.params.id, userId: req.user.id });
    if (!task) {
      return res.status(404).json({ message: "Task not found or unauthorized" });
    }

    await task.deleteOne();
    res.json({ message: "Task deleted successfully" });
  } catch (error) {
    console.error("❌ Error deleting task:", error);
    res.status(500).json({ message: "Server error" });
  }
};
