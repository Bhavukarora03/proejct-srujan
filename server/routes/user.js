const express = require('express');

const authRouter = express.Router();

authRouter.post('/v1/auth/signup', async (request, response) => {
  try{
    const {name, email, profilePicture} = request.body;
  
  
  
  }
  catch(e){}
});