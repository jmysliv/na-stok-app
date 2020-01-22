import crypto from "crypto";
import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import mongoose from "mongoose";
import UserModel, { IUser } from "../models/user.model";
import {config} from "./env.config";

mongoose.set("useFindAndModify", false);

export const isPasswordAndUserMatch = (req: Request, res: Response, next: NextFunction) => {
    UserModel.findOne({email: req.body.email}, (err, user: IUser) => {
            if (!user) {
                res.status(404).send({});
            } else {
                const passwordFields = user.password.split("$");
                const salt = passwordFields[0];
                const hash = crypto.createHmac("sha512", salt).update(req.body.password).digest("base64");
                if (hash === passwordFields[1]) {
                    req.body = {
                        email: user.email,
                        id: user._id,
                        provider: "email",
                    };
                    return next();
                } else {
                    return res.status(400).send({errors: ["Invalid e-mail or password"]});
                }
            }
        });
};

export const checkIfAdmin = (req: Request, res: Response, next: NextFunction) => {
        if (req.body.jwt._id === "admin") {
            return next();
        } else {
            return res.status(403).send();
        }
};
