"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const node_cron_1 = __importDefault(require("node-cron"));
const request_1 = __importDefault(require("request"));
const slope_model_1 = __importDefault(require("../models/slope.model"));
exports.getSlopeByID = (req, res) => {
    slope_model_1.default.findById(req.params.id, (err, result) => {
        if (err) {
            res.status(400).send(err);
        }
        else {
            res.status(200).send(result);
        }
    });
};
exports.getSlopes = (req, res) => {
    slope_model_1.default.find((err, result) => {
        if (err) {
            res.status(400).send(err);
        }
        else {
            res.status(200).send(result);
        }
    });
};
node_cron_1.default.schedule("* 0 * * * *", () => {
    request_1.default("http://127.0.0.1:5000/", (error, response) => {
        if (error) {
            console.log(error);
        }
        else {
            console.log(response.statusCode);
        }
    });
});
//# sourceMappingURL=slopes.controller.js.map