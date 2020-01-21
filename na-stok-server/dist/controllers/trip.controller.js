"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const trip_model_1 = __importDefault(require("../models/trip.model"));
exports.insertTrip = (req, res) => {
    const trip = new trip_model_1.default(req.body);
    trip.save((err, result) => {
        if (err) {
            res.status(400).send({
                message: err,
            });
        }
        else {
            res.status(201).send({
                id: result._id,
            });
        }
    });
};
exports.getTripByID = (req, res) => {
    trip_model_1.default.findById(req.params.id).then((result) => {
        res.status(200).send(result);
    });
};
exports.getTrips = (req, res) => {
    trip_model_1.default.find().then((result) => {
        res.status(200).send(result);
    });
};
exports.putTrip = (req, res) => {
    trip_model_1.default.findByIdAndUpdate(req.params.id, req.body, (err, result) => {
        if (err) {
            res.status(500).send(err);
        }
        else {
            res.status(200).send(result);
        }
    });
};
exports.deleteTripById = (req, res) => {
    trip_model_1.default.findByIdAndRemove(req.params.id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        }
        else {
            res.status(204).send(result);
        }
    });
};
//# sourceMappingURL=trip.controller.js.map