const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();

const app = express();
app.use(express.json());

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('✅ Connected to MongoDB'))
.catch((err) => {
  console.error('❌ MongoDB connection error:', err);
  process.exit(1);
});

// Define User schema & model
const userSchema = new mongoose.Schema({ name: String });
const User = mongoose.model('User', userSchema);

// Root - API metadata
app.get('/', (req, res) => {
  res.json({
    message: "Secure Microservice API",
    version: "1.0.0",
    endpoints: {
      health: "/health",
      users: "/users",
    }
  });
});

// Health Check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// Create User
app.post('/users', async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).json(user);
  } catch (err) {
    console.error('User creation failed:', err);
    res.status(400).json({ error: 'Invalid user data' });
  }
});

// Get All Users
app.get('/users', async (req, res) => {
  try {
    const users = await User.find().lean();
    res.status(200).json(users);
  } catch (err) {
    console.error('User retrieval failed:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`✅ Server running on port ${port}`);
});
