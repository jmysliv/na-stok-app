import crypto from "crypto";
import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import { config } from "./env.config";

export const login = (req: Request, res: Response) => {
    try {
        const refreshId = req.user._id + config.jwt_secret;
        const salt = crypto.randomBytes(16).toString("base64");
        const hash = crypto.createHmac("sha512", salt).update(refreshId).digest("base64");
        req.body.refreshKey = salt;
        const token = jwt.sign(JSON.stringify(req.user), config.jwt_secret);
        const b = new Buffer(hash);
        const refresToken = b.toString("base64");
        res.status(201).send({accessToken: token, refreshToken: refresToken});
    } catch (err) {
        res.status(500).send({errors: err});
    }
};
