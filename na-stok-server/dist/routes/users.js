"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const validation_middleware_1 = require("../auth/validation.middleware");
const user_controller_1 = require("./../controllers/user.controller");
const userRouter = express_1.default.Router();
userRouter.get("/", [validation_middleware_1.validJWTNeeded, user_controller_1.userGet]);
userRouter.post("/", user_controller_1.insertUser);
userRouter.get("/:id", [validation_middleware_1.validJWTNeeded, user_controller_1.userGetById]);
userRouter.put("/:id", [validation_middleware_1.validJWTNeeded, user_controller_1.userPut]);
userRouter.delete("/:id", [validation_middleware_1.validJWTNeeded, user_controller_1.userDelete]);
exports.default = userRouter;
//# sourceMappingURL=users.js.map