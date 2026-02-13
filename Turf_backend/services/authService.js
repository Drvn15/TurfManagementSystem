const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

const JWT_SECRET = "super_secret_key"; // later move to .env

// Register user
const registerUser = async (name, phone, password, role = "USER") => {
  const existingUser = await User.findOne({ where: { phone } });

  if (existingUser) {
    throw new Error("User already exists");
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await User.create({
    name,
    phone,
    password: hashedPassword,
    role,
  });

  return user;
};

// Login user
const loginUser = async (phone, password) => {
  const user = await User.findOne({ where: { phone } });

  if (!user) {
    throw new Error("Invalid credentials");
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    throw new Error("Invalid credentials");
  }

  const token = jwt.sign(
    { id: user.id, role: user.role },
    JWT_SECRET,
    { expiresIn: "1d" }
  );

  return token;
};

module.exports = {
  registerUser,
  loginUser,
};
