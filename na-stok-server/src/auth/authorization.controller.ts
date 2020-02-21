import crypto from "crypto";
import { Request, Response } from "express";
import jwt from "jsonwebtoken";
import { config } from "./env.config";

export const login = (req: Request, res: Response) => {
    try {
        const token = jwt.sign(JSON.parse(JSON.stringify(req.user)), config.jwt_secret, {expiresIn: 86400});
        res.status(201).send({accessToken: token});
    } catch (err) {
        console.log(err);
        res.status(500).send({errors: err});
    }
};
