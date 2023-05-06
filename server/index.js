const express = require("express");
const mongoose = require("mongoose");

const PORT = process.env.PORT || 3001;

const app = express();
const DB = "mongodb+srv://bhavukarora:n88Rre2yDe3EFYWx@cluster0.06g8qxw.mongodb.net/";


mongoose.connect(DB).then(() => console.log("MongoDB connected...")).catch(err => console.log(err));  

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server listening on ${PORT} blah blah shit`);

});