"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const crypto_1 = __importDefault(require("crypto"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_config_1 = require("./env.config");
exports.login = (req, res) => {
    try {
        const refreshId = req.user._id + env_config_1.config.jwt_secret;
        const salt = crypto_1.default.randomBytes(16).toString("base64");
        const hash = crypto_1.default.createHmac("sha512", salt).update(refreshId).digest("base64");
        req.body.refreshKey = salt;
        const token = jsonwebtoken_1.default.sign(JSON.stringify(req.user), env_config_1.config.jwt_secret);
        const b = new Buffer(hash);
        const refresToken = b.toString("base64");
        res.status(201).send({ accessToken: token, refreshToken: refresToken });
    }
    catch (err) {
        res.status(500).send({ errors: err });
    }
};
//# sourceMappingURL=authorization.controller.js.map