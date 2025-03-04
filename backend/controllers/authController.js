const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");

dotenv.config();

exports.registerUser = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    console.log("🔹 Registering User:", { name, email });

    
    if (!name || !email || !password) {
      return res.status(400).json({ message: "All fields are required." });
    }


    const existingUser = await User.findOne({ email });
    if (existingUser) {
      console.log("⚠️ User already exists:", email);
      return res.status(400).json({ message: "User already exists" });
    }


    const hashedPassword = await bcrypt.hash(password, 10);


    const newUser = new User({ name, email, password: hashedPassword });
    await newUser.save();

    console.log("✅ New User Created:", newUser);

    if (!newUser._id) {
      console.error("❌ Error: newUser._id is undefined!");
      return res.status(500).json({ message: "Error creating user" });
    }

  
    if (!process.env.JWT_SECRET) {
      console.error("❌ Error: JWT_SECRET is missing in .env file!");
      return res.status(500).json({ message: "Server configuration error" });
    }

    
    const token = jwt.sign({ id: newUser._id }, process.env.JWT_SECRET, { expiresIn: "1h" });
    console.log("🔐 Generated Token:", token);


    res.status(201).json({
      message: "User registered successfully",
      token,
      user: { id: newUser._id, name: newUser.name, email: newUser.email },
    });

  } catch (error) {
    console.error("❌ Server Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};
