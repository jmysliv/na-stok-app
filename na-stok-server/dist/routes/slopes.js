"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const validation_middleware_1 = require("./../auth/validation.middleware");
const slopes_controller_1 = require("./../controllers/slopes.controller");
const slopesRouter = express_1.default.Router();
slopesRouter.get("/", [validation_middleware_1.validJWTNeeded, slopes_controller_1.getSlopes]);
slopesRouter.get("/:id", [validation_middleware_1.validJWTNeeded, slopes_controller_1.getSlopeByID]);
exports.default = slopesRouter;
//# sourceMappingURL=slopes.js.map