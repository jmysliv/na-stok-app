"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const messages_model_1 = __importDefault(require("../models/messages.model"));
const socket_1 = require("./../socket");
exports.postMessage = (req, res) => {
    const message = new messages_model_1.default(req.body);
    message.save((err, result) => {
        if (err) {
            res.status(400).send({
                message: err,
            });
        }
        else {
            delete req.body.jwt;
            const io = socket_1.socketConfig.getio();
            io.emit("message", req.body);
            res.status(201).send();
        }
    });
};
exports.getMessageByTripID = (req, res) => {
    messages_model_1.default.find({ tripId: req.params.id }, (err, result) => {
        if (err) {
            res.status(400).send(err);
        }
        else {
            res.status(200).send(result);
        }
    });
};
exports.getMessages = (req, res) => {
    messages_model_1.default.find((err, result) => {
        if (err) {
            res.status(400).send(err);
        }
        else {
            res.status(200).send(result);
        }
    });
};
exports.deleteMessageById = (req, res) => {
    messages_model_1.default.findByIdAndRemove(req.params.id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        }
        else {
            res.status(204).send(result);
        }
    });
};
//# sourceMappingURL=messages.controller.js.map