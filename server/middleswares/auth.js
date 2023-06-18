const jwt = require("jsonwebtoken");

const auth = async (request, response, next) => {
    try {
        const token = request.header("x-auth-token");
        if (!token)
            return response
                .status(401)
                .json({message: "No authentication token, authorization denied"});

        const verified = jwt.verify(token, 'passwordKey');

        if (!verified)
            return response.status(401).json({message: "Token verification failed, authorization denied"});

        request.user = verified.id;
        request.token = token;
        next();
    } catch (e) {
        response.status(500).json({message: e.message});
    }
};

module.exports = auth;