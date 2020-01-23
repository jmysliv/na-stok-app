import cookieParser from "cookie-parser";
import cors from "cors";
import express, { NextFunction } from "express";
import jwt from "jsonwebtoken";
import mongoose from "mongoose";
import logger from "morgan";
import path from "path";
import { Socket } from "socket.io";
import socketioJwt from "socketio-jwt";
import {config} from "./auth/env.config";
import authRouter from "./auth/route";
import meRouter from "./routes/me";
import messageRouter from "./routes/messages";
import slopesRouter from "./routes/slopes";
import tripRouter from "./routes/trips";
import userRouter from "./routes/users";
import {SocketManager} from "./socket";

mongoose.connect("mongodb://localhost/na-stok-app", {useUnifiedTopology: true, useNewUrlParser: true});
const db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error:"));
db.once("open", () => {
    console.log("connected with mongo");
});

const app = express();
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "../public")));
app.use(cors());
app.use("/trips", tripRouter);
app.use("/slopes", slopesRouter);
app.use("/auth", authRouter);
app.use("/users", userRouter);
app.use("/messages", messageRouter);
app.use("/me", meRouter);

const server = app.listen(3000, "localhost", (e) => {
    console.log("running");
});

const socketManager = SocketManager.getInstance();
const io = socketManager.init(server);
io.use((socket: Socket, next: NextFunction) => {
    if (socket.handshake.query && socket.handshake.query.token) {
      jwt.verify(socket.handshake.query.token, config.jwt_secret , (err: Error, decodedToken: any) => {
        if (err) {
            socket.disconnect();
            return next(new Error("Authentication error"));
        } else {
            socketManager.addSocketUser(socket.id, decodedToken._id);
            next();
        }
      });
    } else {
        socket.disconnect();
        next(new Error("Authentication error"));
    }
  })
  .on("connection", (socket: any) => {
     console.log("Socket connected: " + socket.id);
     socket.on("disconnect", () => {
       socketManager.removeSocketUser(socket.id);
     });
  });

export default app;
