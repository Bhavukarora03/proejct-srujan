const moongoose = require('mongoose');


const DocumentSchema = new moongoose.Schema({
    uid: {
        required: true,
        type: String
    },
    createdAt: {
        required: true,
        type: Number
    },
    title: {
        required: true,
        type: String,
        trim: true
    },
    content: {
        type: Array,
        default: []
    }
});

const document = module.exports = moongoose.model('Document', DocumentSchema);
module.exports = document;