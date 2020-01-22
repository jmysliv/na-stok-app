import express from "express";
import { validJWTNeeded } from "./../auth/validation.middleware";
import { deleteMessageById, getMessageByTripID, getMessages, postMessage } from "./../controllers/messages.controller";
const messageRouter = express.Router();

messageRouter.get("/", [validJWTNeeded, getMessages]);

messageRouter.post("/", [validJWTNeeded, postMessage]);

messageRouter.get("/:id", [validJWTNeeded, getMessageByTripID]);

messageRouter.delete("/:id", [validJWTNeeded, deleteMessageById]);

export default messageRouter;
