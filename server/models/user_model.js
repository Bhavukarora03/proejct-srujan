const mongoose = require("mongoose");

const userSchema = mongoose.schema({
 
  name: {
    type: String,
    required: true,
    
  }

});