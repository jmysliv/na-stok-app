"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const cookie_parser_1 = __importDefault(require("cookie-parser"));
const cors_1 = __importDefault(require("cors"));
const express_1 = __importDefault(require("express"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const mongoose_1 = __importDefault(require("mongoose"));
const morgan_1 = __importDefault(require("morgan"));
const path_1 = __importDefault(require("path"));
const env_config_1 = require("./auth/env.config");
const route_1 = __importDefault(require("./auth/route"));
const me_1 = __importDefault(require("./routes/me"));
const messages_1 = __importDefault(require("./routes/messages"));
const slopes_1 = __importDefault(require("./routes/slopes"));
const trips_1 = __importDefault(require("./routes/trips"));
const users_1 = __importDefault(require("./routes/users"));
const socket_1 = require("./socket");
mongoose_1.default.connect("mongodb://localhost/na-stok-app", { useUnifiedTopology: true, useNewUrlParser: true });
const db = mongoose_1.default.connection;
db.on("error", console.error.bind(console, "connection error:"));
db.once("open", () => {
    console.log("connected with mongo");
});
const app = express_1.default();
app.use(morgan_1.default("dev"));
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: false }));
app.use(cookie_parser_1.default());
app.use(express_1.default.static(path_1.default.join(__dirname, "../public")));
app.use(cors_1.default());
app.use("/trips", trips_1.default);
app.use("/slopes", slopes_1.default);
app.use("/auth", route_1.default);
app.use("/users", users_1.default);
app.use("/messages", messages_1.default);
app.use("/me", me_1.default);
const server = app.listen(3000, "0.0.0.0", (e) => {
    console.log("running");
});
const socketManager = socket_1.SocketManager.getInstance();
const io = socketManager.init(server);
io.use((socket, next) => {
    if (socket.handshake.query && socket.handshake.query.token) {
        jsonwebtoken_1.default.verify(socket.handshake.query.token, env_config_1.config.jwt_secret, (err, decodedToken) => {
            if (err) {
                socket.disconnect();
                return next(new Error("Authentication error"));
            }
            else {
                socketManager.addSocketUser(socket.id, decodedToken._id);
                next();
            }
        });
    }
    else {
        socket.disconnect();
        next(new Error("Authentication error"));
    }
})
    .on("connection", (socket) => {
    console.log("Socket connected: " + socket.id);
    socket.on("disconnect", () => {
        console.log("Socket disconnected: " + socket.id);
        socketManager.removeSocketUser(socket.id);
    });
});
exports.default = app;
//# sourceMappingURL=app.js.map