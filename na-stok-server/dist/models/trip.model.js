"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const tripSchema = new mongoose_1.default.Schema({
    creator: {
        required: true,
        type: String,
    },
    departureDateTime: {
        required: true,
        type: Date,
    },
    latitude: {
        required: true,
        type: Number,
    },
    longitude: {
        required: true,
        type: Number,
    },
    maxParticipants: {
        min: 1,
        required: true,
        type: Number,
    },
    participants: {
        type: [String],
    },
    participantsRequest: {
        type: [String],
    },
    prize: {
        min: 0,
        type: Number,
    },
    slope: {
        required: true,
        type: String,
    },
});
const TripModel = mongoose_1.default.model("Trips", tripSchema);
mongoose_1.default.set("useFindAndModify", false);
exports.default = TripModel;
//# sourceMappingURL=trip.model.js.map