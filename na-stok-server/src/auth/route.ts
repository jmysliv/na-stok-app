import express from "express";
import { login } from "../auth/authorization.controller";
import { validJWTNeeded} from "../auth/validation.middleware";
import { isPasswordAndUserMatch } from "../auth/verify.user.middleware";
const authRouter = express.Router();

authRouter.post("/", [
        isPasswordAndUserMatch,
        login,
    ]);

export default authRouter;
