"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_config_1 = require("./env.config");
exports.login = (req, res) => {
    try {
        const token = jsonwebtoken_1.default.sign(JSON.parse(JSON.stringify(req.user)), env_config_1.config.jwt_secret, { expiresIn: 86400 });
        res.status(201).send({ accessToken: token });
    }
    catch (err) {
        console.log(err);
        res.status(500).send({ errors: err });
    }
};
//# sourceMappingURL=authorization.controller.js.map