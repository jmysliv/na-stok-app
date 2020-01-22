"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const validation_middleware_1 = require("./../auth/validation.middleware");
const messages_controller_1 = require("./../controllers/messages.controller");
const messageRouter = express_1.default.Router();
messageRouter.get("/", [validation_middleware_1.validJWTNeeded, messages_controller_1.getMessages]);
messageRouter.post("/", [validation_middleware_1.validJWTNeeded, messages_controller_1.postMessage]);
messageRouter.get("/:id", [validation_middleware_1.validJWTNeeded, messages_controller_1.getMessageByTripID]);
messageRouter.delete("/:id", [validation_middleware_1.validJWTNeeded, messages_controller_1.deleteMessageById]);
exports.default = messageRouter;
//# sourceMappingURL=messages.js.map