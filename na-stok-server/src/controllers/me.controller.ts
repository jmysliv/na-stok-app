import { Request, Response } from "express";
import UserModel from "../models/user.model";
import { IUser } from "./../models/user.model";

export const getUserByToken = (req: Request, res: Response) => {
    UserModel.findById(req.body.jwt.userId, (err, result: IUser) => {
        if (err) {
            res.status(400).send(err);
        } else {
            delete result.password;
            res.status(200).send(result) ;
        }
    });
 };
