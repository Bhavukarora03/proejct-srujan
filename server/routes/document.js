const express = require("express");
const Document = require("../models/document_model");
const auth = require("../middleswares/auth");
const documentRouter = express.Router();


documentRouter.post("/v1/document/create", auth, async (req, res,) => {
    try {
        const {createdAt} = req.body;
        let document = new Document({
            uid: req.user,
            createdAt: createdAt,
            title: 'Untitled',

        });

        document = await document.save();
        res.json({document: document});
    } catch (e) {
        res.status(500).json({message: e.message});
    }
});

documentRouter.get("/v1/document/me", auth, async (req, res,) => {
    try {
        let documents = await Document.find({uid: req.user});
        res.json({documents: documents});

    } catch (e) {
        res.status(500).json({message: e.message});
    }
});

documentRouter.post("v1/document/title", auth, async (req, res,) => {
    try {
        const {id, title} = req.body;
        const document = await Document.findOneAndUpdate(id, {title: title});
        res.json({document: document});
    } catch (e) {
        res.status(500).json({message: e.message});
    }

});

documentRouter.get("v1/document/:id", auth, async (req, res) => {
    try {
        const document = await Document.findById(req.params.id);
        res.json(document);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

module.exports = documentRouter;
