"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_config_1 = require("./env.config");
exports.validJWTNeeded = (req, res, next) => {
    if (req.headers.authorization) {
        try {
            const authorization = req.headers.authorization.split(" ");
            if (authorization[0] !== "Bearer") {
                return res.status(401).send();
            }
            else {
                req.body.jwt = jsonwebtoken_1.default.verify(authorization[1], env_config_1.config.jwt_secret);
                return next();
            }
        }
        catch (err) {
            console.log(err);
            return res.status(403).send();
        }
    }
    else {
        return res.status(401).send();
    }
};
//# sourceMappingURL=validation.middleware.js.map