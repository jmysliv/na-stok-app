"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const user_model_1 = __importDefault(require("../models/user.model"));
exports.getUserByToken = (req, res) => {
    user_model_1.default.findById(req.user._id, (err, result) => {
        if (err) {
            res.status(400).send(err);
        }
        else {
            delete result.password;
            res.status(200).send(result);
        }
    });
};
//# sourceMappingURL=me.controller.js.map