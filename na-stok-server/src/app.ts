import cookieParser from "cookie-parser";
import cors from "cors";
import express from "express";
import mongoose from "mongoose";
import logger from "morgan";
import path from "path";
import authRouter from "./auth/route";
import slopesRouter from "./routes/slopes";
import tripRouter from "./routes/trips";
import userRouter from "./routes/users";

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

app.listen(3000, "localhost", (e) => {
    console.log("running");
});
export default app;
