"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const validation_middleware_1 = require("./../auth/validation.middleware");
const trip_controller_1 = require("./../controllers/trip.controller");
const tripRouter = express_1.default.Router();
tripRouter.get("/", [validation_middleware_1.validJWTNeeded, trip_controller_1.getTrips]);
tripRouter.post("/", [validation_middleware_1.validJWTNeeded, trip_controller_1.insertTrip]);
// handling request with specified id(get, patch, delete)
tripRouter.get("/:id", [validation_middleware_1.validJWTNeeded, trip_controller_1.getTripByID]);
tripRouter.put("/:id", [validation_middleware_1.validJWTNeeded, trip_controller_1.putTrip]);
tripRouter.delete("/:id", [validation_middleware_1.validJWTNeeded, trip_controller_1.deleteTripById]);
exports.default = tripRouter;
//# sourceMappingURL=trips.js.map