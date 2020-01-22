import express from "express";
import { validJWTNeeded } from "../auth/validation.middleware";
import { getUserByToken } from "../controllers/me.controller";

const meRouter = express.Router();

meRouter.get("/", [
        validJWTNeeded,
        getUserByToken,
    ]);

export default meRouter;
