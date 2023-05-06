const express = require("express");
const User = require("../models/user_model");

const authRouter = express.Router();

authRouter.post("/v1/auth/signup", async (request, response) => {
  try {
    const { name, email, profilePicture } = request.body;

    let user = await User.findOne({ email: email});
    if (!user) {
      user = new User({
        name: name,
        email: email,
        profilePicture: profilePicture,
      });
      user = await user.save();
    }
    response.json({ user: user });
  } catch (e) {
    console.log(e);
  }
});

module.exports = authRouter;
