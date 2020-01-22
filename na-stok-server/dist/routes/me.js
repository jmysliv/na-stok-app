"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const validation_middleware_1 = require("../auth/validation.middleware");
const me_controller_1 = require("../controllers/me.controller");
const meRouter = express_1.default.Router();
meRouter.get("/", [
    validation_middleware_1.validJWTNeeded,
    me_controller_1.getUserByToken,
]);
exports.default = meRouter;
//# sourceMappingURL=me.js.map