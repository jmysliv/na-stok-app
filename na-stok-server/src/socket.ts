import {Server } from "http";
import ioImport from "socket.io";
let io: SocketIO.Server;
export const socketConfig = {
    init(server: Server): SocketIO.Server {
        // start socket.io server and cache io value
        io = ioImport(server);
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
