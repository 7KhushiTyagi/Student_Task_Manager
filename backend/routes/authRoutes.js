const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
require("dotenv").config(); 

const router = express.Router();

if (!process.env.JWT_SECRET) {
  // Log an error message if JWT_SECRET is not defined in the environment variables
  console.error("❌ ERROR: JWT_SECRET is missing in .env file!");
  process.exit(1); 
}

// 🔹 User Registration
router.post("/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;
    console.log("Registering User:", { name, email });

    const normalizedEmail = email.toLowerCase();

    let user = await User.findOne({ email: normalizedEmail });
    if (user) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    user = new User({ name, email: normalizedEmail, password: hashedPassword });
    await user.save();

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1h" });

    res.status(201).json({
      message: "User registered successfully",
      token,
      user: { id: user._id, name: user.name, email: user.email },
    });

  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

// 🔹 User Login
router.post("/login", async (req, res) => {
  try {
    let { email, password } = req.body;
    email = email.toLowerCase();

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: "1h" });

    res.json({
      message: "Login successful",
      token,
      user: { id: user._id, name: user.name, email: user.email },
    });

  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

// 🔹 User Logout
router.post("/logout", (req, res) => {
  res.json({ message: "Logged out successfully" });
});

module.exports = router;
