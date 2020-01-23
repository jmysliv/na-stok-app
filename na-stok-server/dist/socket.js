"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const socket_io_1 = __importDefault(require("socket.io"));
class SocketManager {
    constructor() {
        this.io = null;
        this.socketUsers = new Array();
        if (SocketManager.instance) {
            throw new Error("Error: Instantiation failed: Use SingletonClass.getInstance() instead of new.");
        }
        SocketManager.instance = this;
    }
    static getInstance() {
        return SocketManager.instance;
    }
    init(server) {
        // start socket.io server and cache io value
        this.io = socket_io_1.default(server);
        return this.io;
    }
    getio() {
        // return previously cached value
        if (this.io === null) {
            throw new Error("must call .init(server) before you can call .getio()");
        }
        return this.io;
    }
    getSocketUsers() {
        return this.socketUsers;
    }
    addSocketUser(sID, uID) {
        const socketUser = { socketId: sID, userId: uID };
        this.socketUsers.push(socketUser);
    }
    removeSocketUser(sID) {
        this.socketUsers = this.socketUsers.filter((x) => x.socketId !== sID);
    }
}
exports.SocketManager = SocketManager;
SocketManager.instance = new SocketManager();
//# sourceMappingURL=socket.js.map