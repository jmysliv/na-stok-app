import express from "express";
import { getSlopeByID, getSlopes } from "./../controllers/slopes.controller";
const slopesRouter = express.Router();

slopesRouter.get("/", getSlopes);

slopesRouter.get("/:id", getSlopeByID);

export default slopesRouter;
