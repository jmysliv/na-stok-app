"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const crypto_1 = __importDefault(require("crypto"));
const mongoose_1 = __importDefault(require("mongoose"));
const user_model_1 = __importDefault(require("../models/user.model"));
mongoose_1.default.set("useFindAndModify", false);
exports.isPasswordAndUserMatch = (req, res, next) => {
    user_model_1.default.findOne({ email: req.body.email }, (err, user) => {
        if (!user) {
            res.status(404).send({});
        }
        else {
            const passwordFields = user.password.split("$");
            const salt = passwordFields[0];
            const hash = crypto_1.default.createHmac("sha512", salt).update(req.body.password).digest("base64");
            if (hash === passwordFields[1]) {
                req.user = user;
                return next();
            }
            else {
                return res.status(400).send({ errors: ["Invalid e-mail or password"] });
            }
        }
    });
};
exports.checkIfAdmin = (req, res, next) => {
    if (req.user.email === "admin@admin.com") {
        return next();
    }
    else {
        return res.status(403).send();
    }
};
//# sourceMappingURL=verify.user.middleware.js.map