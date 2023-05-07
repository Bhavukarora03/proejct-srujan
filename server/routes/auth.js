const express = require("express");
const User = require("../models/user_model");
const jwt = require("jsonwebtoken");
const authRouter = express.Router();
const auth = require("../middlewares/auth");

authRouter.post("/v1/auth/signup", async (request, response) => {
  try {
    const { name, email, profilePicture } = request.body;

    let user = await User.findOne({ email: email });
    if (!user) {
      user = new User({
        name: name,
        email: email,
        profilePicture: profilePicture,
      });
      user = await user.save();
    }
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
    response.json({ user: user, token: token });
  } catch (e) {
    response.status(500).json({ message: e.message });
  }
});

authRouter.get("/", auth, async (request, response) => {
  const user = await User.findById(request.user);
  response.json({ user, token: request.token });
});
module.exports = authRouter;
