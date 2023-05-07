const express = require("express"); // just like importing in dart
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require("./routes/auth");
require("dotenv").config(); // this is for the .env file

const PORT = process.env.PORT || 3001; // process.env.PORT is for heroku deployment and 3001 is for local deployment

const app = express();

app.use(cors()); 
app.use(express.json()); // this is a middleware
app.use(authRouter); // this is a middleware
const DB = process.env.MONGODB_CONNECTION; // creating an express app

mongoose
  .connect(DB)
  .then(() => console.log("MongoDB connected..."))
  .catch((err) => console.log(err));

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server listening on ${PORT} blah blah shit`);
});
