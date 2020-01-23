import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { IUser } from "./../models/user.model";
import {config} from "./env.config";

export const validJWTNeeded = (req: Request, res: Response, next: NextFunction) => {
    if (req.headers.authorization) {
        try {
            const authorization = req.headers.authorization.split(" ");
            if (authorization[0] !== "Bearer") {
                return res.status(401).send();
            } else {
                req.user = jwt.verify(authorization[1], config.jwt_secret) as IUser;
                return next();
            }

        } catch (err) {
            console.log(err);
            return res.status(403).send();
        }
    } else {
        return res.status(401).send();
    }
};
