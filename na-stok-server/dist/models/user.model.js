"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const userSchema = new mongoose_1.default.Schema({
    email: {
        required: true,
        type: String,
        unique: true,
        validate: {
            validator: (v) => {
                return /\S+@\S+\.\S+/.test(v);
            },
        },
    },
    name: {
        required: true,
        type: String,
    },
    password: {
        required: true,
        type: String,
    },
});
const UserModel = mongoose_1.default.model("Users", userSchema);
mongoose_1.default.set("useFindAndModify", false);
exports.default = UserModel;
//# sourceMappingURL=user.model.js.map