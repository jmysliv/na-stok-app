import express from "express";
import { validJWTNeeded } from "../auth/validation.middleware";
import { checkIfAdmin } from "../auth/verify.user.middleware";
import { insertUser, userDelete, userGet, userGetById, userPut } from "./../controllers/user.controller";
const userRouter = express.Router();

userRouter.get("/",  [validJWTNeeded, userGet]);

userRouter.post("/", insertUser);

userRouter.get("/:id", [validJWTNeeded, userGetById]);

userRouter.put("/:id", [validJWTNeeded, userPut]);

userRouter.delete("/:id", [validJWTNeeded, userDelete]);

export default userRouter;
