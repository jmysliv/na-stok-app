"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const messageSchema = new mongoose_1.default.Schema({
    authorId: {
        required: true,
        type: String,
    },
    authorName: {
        required: true,
        type: String,
    },
    content: {
        required: true,
        type: String,
    },
    dateTime: {
        required: true,
        type: Date,
    },
    tripId: {
        required: true,
        type: String,
    },
});
const MessageModel = mongoose_1.default.model("Messages", messageSchema);
mongoose_1.default.set("useFindAndModify", false);
exports.default = MessageModel;
//# sourceMappingURL=messages.model.js.map