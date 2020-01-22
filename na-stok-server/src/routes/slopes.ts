import express from "express";
import { validJWTNeeded } from "./../auth/validation.middleware";
import { getSlopeByID, getSlopes } from "./../controllers/slopes.controller";
const slopesRouter = express.Router();

slopesRouter.get("/", [ validJWTNeeded, getSlopes]);

slopesRouter.get("/:id", [validJWTNeeded, getSlopeByID]);

export default slopesRouter;
