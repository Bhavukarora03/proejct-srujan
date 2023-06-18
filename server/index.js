const express = require("express");
const mongoose = require("mongoose").default;
const cors = require("cors");
const authRouter = require("./routes/auth");
const documentRouter = require("./routes/document");
require("dotenv").config();

const PORT = process.env.PORT || 3001;
const app = express();

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);
const DB = process.env.MONGODB_CONNECTION;
mongoose.connect(DB).then(() => console.log("MongoDB connected...")).catch((err) => console.log(err));

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server listening on ${PORT}`);
});
