import express from "express";
import { validJWTNeeded } from "./../auth/validation.middleware";
import { deleteTripById, getTripByID, getTrips, insertTrip, putTrip } from "./../controllers/trip.controller";
const tripRouter = express.Router();

tripRouter.get("/", [validJWTNeeded, getTrips]);

tripRouter.post("/", [validJWTNeeded, insertTrip]);

// handling request with specified id(get, patch, delete)

tripRouter.get("/:id", [validJWTNeeded, getTripByID]);

tripRouter.put("/:id", [validJWTNeeded, putTrip]);

tripRouter.delete("/:id", [validJWTNeeded, deleteTripById]);

export default tripRouter;
