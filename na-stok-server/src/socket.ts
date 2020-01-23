import {Server } from "http";
import ioImport from "socket.io";
import SocketIO from "socket.io";

export class SocketManager {
    public static getInstance(): SocketManager {
        return SocketManager.instance;
    }
    private static instance: SocketManager = new SocketManager();
    private io: SocketIO.Server = null;
    private  socketUsers = new Array<{
            socketId: string,
            userId: string,
        }>();
    constructor() {
        if (SocketManager.instance) {
            throw new Error("Error: Instantiation failed: Use SingletonClass.getInstance() instead of new.");
        }
        SocketManager.instance = this;
    }
    public init(server: Server): SocketIO.Server {
            // start socket.io server and cache io value
            this.io = ioImport(server);
            return this.io;
        }
    public getio() {
            // return previously cached value
            if (this.io === null) {
                throw new Error("must call .init(server) before you can call .getio()");
            }
            return this.io;
        }
    public getSocketUsers() {
        return this.socketUsers;
    }
    public addSocketUser(sID: string, uID: string) {
        const socketUser = { socketId: sID, userId: uID};
        this.socketUsers.push(socketUser);
    }
    public removeSocketUser(sID: string) {
        this.socketUsers = this.socketUsers.filter( (x) => x.socketId !== sID);
    }
}
