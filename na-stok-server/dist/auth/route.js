"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const authorization_controller_1 = require("../auth/authorization.controller");
const verify_user_middleware_1 = require("../auth/verify.user.middleware");
const authRouter = express_1.default.Router();
authRouter.post("/", [
    verify_user_middleware_1.isPasswordAndUserMatch,
    authorization_controller_1.login,
]);
exports.default = authRouter;
//# sourceMappingURL=route.js.map