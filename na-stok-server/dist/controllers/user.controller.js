"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const crypto_1 = __importDefault(require("crypto"));
const mongoose_1 = __importDefault(require("mongoose"));
const user_model_1 = __importDefault(require("../models/user.model"));
exports.insertUser = (req, res) => {
    const salt = crypto_1.default.randomBytes(16).toString("base64");
    const hash = crypto_1.default.createHmac("sha512", salt)
        .update(req.body.password)
        .digest("base64");
    req.body.password = salt + "$" + hash;
    const newUser = new user_model_1.default(req.body);
    user_model_1.default.findOne({ email: req.body.email }, (err, user) => {
        if (user) {
            res.status(406).send({ error: "Given email exists in database" });
        }
        else {
            newUser.save((error, result) => {
                if (error) {
                    res.status(400).send(error);
                }
                else {
                    res.status(201).send({ id: result._id });
                }
            });
        }
    });
};
exports.userGetById = (req, res) => {
    if (!mongoose_1.default.Types.ObjectId.isValid(req.params.id)) {
        res.status(400).send({ message: "invalid id syntax" });
        return;
    }
    user_model_1.default.findById(req.params.id).then((result) => {
        if (result) {
            res.status(200).send(result);
        }
        else {
            res.status(404).send({ message: "not found" });
        }
    });
};
exports.userGet = (req, res) => {
    user_model_1.default.find((err, result) => {
        if (result) {
            res.status(200).send(result);
        }
        else {
            res.status(200).send(result);
        }
    });
};
exports.userPut = (req, res) => {
    user_model_1.default.findByIdAndUpdate(req.params.id, req.body, (err, result) => {
        if (err) {
            res.status(500).send(err);
        }
        else {
            res.status(200).send(result);
        }
    });
};
exports.userDelete = (req, res) => {
    user_model_1.default.findByIdAndRemove(req.params.id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        }
        else {
            res.status(204).send();
        }
    });
};
//# sourceMappingURL=user.controller.js.map