"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const socket_io_1 = __importDefault(require("socket.io"));
let io;
exports.socketConfig = {
    init(server) {
        // start socket.io server and cache io value
        io = socket_io_1.default(server);
        return io;
    },
    getio() {
        // return previously cached value
        if (!io) {
            throw new Error("must call .init(server) before you can call .getio()");
        }
        return io;
    },
};
//# sourceMappingURL=socket.js.map