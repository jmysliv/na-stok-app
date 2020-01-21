import express from "express";
import { deleteTripById, getTripByID, getTrips, insertTrip, putTrip } from "./../controllers/trip.controller";
const tripRouter = express.Router();

tripRouter.get("/", getTrips);

tripRouter.post("/", insertTrip);

// handling request with specified id(get, patch, delete)

tripRouter.get("/:id", getTripByID);

tripRouter.put("/:id", putTrip);

tripRouter.delete("/:id", deleteTripById);

export default tripRouter;
