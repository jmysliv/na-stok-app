"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const messages_model_1 = __importDefault(require("../models/messages.model"));
const trip_model_1 = __importDefault(require("../models/trip.model"));
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
            delete req.user;
            const socketManager = socket_1.SocketManager.getInstance();
            const io = socketManager.getio();
            const tripParticipants = [];
            trip_model_1.default.findById(req.body.tripId, (error, trip) => {
                tripParticipants.push(trip.creator);
                trip.participants.forEach((participant) => {
                    tripParticipants.push(participant);
                });
            }).then(() => {
                let socketUsers = socketManager.getSocketUsers();
                socketUsers = socketUsers.filter((socketUser) => {
                    let flag = false;
                    tripParticipants.forEach((participant) => {
                        if (socketUser.userId === participant) {
                            flag = true;
                        }
                    });
                    return flag;
                });
                socketUsers.forEach((socketUser) => {
                    io.to(`${socketUser.socketId}`).emit("message", req.body);
                });
                res.status(201).send();
            });
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