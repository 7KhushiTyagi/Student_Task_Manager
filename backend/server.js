const express = require("express");
require("dotenv").config();
const mongoose = require("mongoose");
const cors = require("cors");

const authRoutes = require("./routes/authRoutes");
const taskRoutes = require("./routes/taskRoutes");

const app = express();
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI;
const CLIENT_ORIGIN = process.env.CLIENT_ORIGIN || "*"; // 🔹 Restrict in production

// ✅ Middleware
app.use(express.json());

// ✅ CORS Middleware (Improved Security)
app.use(cors({ origin: CLIENT_ORIGIN, credentials: true }));

// ✅ Handle Preflight Requests (`OPTIONS`)
app.options("*", cors());

// ✅ Ensure MongoDB is Connected
if (!MONGO_URI) {
  console.error("❌ MONGO_URI is missing in .env file!");
  process.exit(1);
} else {
  mongoose
    .connect(MONGO_URI)
    .then(() => console.log("✅ MongoDB Connected"))
    .catch((err) => {
      console.error("❌ MongoDB Connection Error:", err);
      // 🔹 Instead of exiting, log an error (optional: retry connection)
    });
}

app.use((req, res, next) => {
  console.log(`📩 Received: ${req.method} ${req.url}`);
  next();
});


// ✅ Routes
app.use("/api/auth", authRoutes);
app.use("/api/tasks", taskRoutes);

// ✅ Global Error Handler
app.use((err, req, res, next) => {
  console.error("🔥 Unhandled Error:", err);
  res.status(500).json({ error: "Internal Server Error" });
});

// ✅ Start Server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://127.0.0.1:${PORT}`);

});
