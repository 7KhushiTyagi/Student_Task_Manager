const jwt = require("jsonwebtoken");
require("dotenv").config(); 

module.exports = (req, res, next) => {
  try {
    const authHeader = req.header("Authorization");

    // ✅ Validate Authorization header format
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      console.warn("⚠️ Missing or invalid Authorization header.");
      return res.status(401).json({ message: "Access denied. No token provided." });
    }

    const token = authHeader.split(" ")[1]; 

    if (!process.env.JWT_SECRET) {
      console.error("❌ Error: JWT_SECRET is missing in .env file!");
      return res.status(500).json({ message: "Server configuration error" });
    }

  
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    
    req.user = { id: decoded.id };

    console.log("✅ User authenticated:", req.user);

    next(); 
  } catch (err) {
    console.error("❌ Invalid or Expired Token:", err.message);
    return res.status(401).json({ message: "Invalid or expired token" });
  }
};
