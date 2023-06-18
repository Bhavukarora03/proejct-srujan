const mongoose = require("mongoose").default;

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true, // this is a validation
    },
    profilePicture: {
        type: String,
        required: true,
    },
});

const User = mongoose.model("User", userSchema);
module.exports = User;