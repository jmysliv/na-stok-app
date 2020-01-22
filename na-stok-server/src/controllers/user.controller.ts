import crypto from "crypto";
import { Request, Response } from "express";
import mongoose from "mongoose";
import UserModel from "../models/user.model";

export const insertUser = (req: Request, res: Response) => {
    const salt = crypto.randomBytes(16).toString("base64");
    const hash = crypto.createHmac("sha512", salt)
                                     .update(req.body.password)
                                     .digest("base64");
    req.body.password = salt + "$" + hash;
    const newUser = new UserModel(req.body);
    UserModel.findOne({email: req.body.email}, (err, user) => {
        if (user) {
            res.status(406).send({error: "Given email exists in database"});
        } else {
            newUser.save( (error, result) => {
                if (error) {
                    res.status(400).send(error);
                } else {
                    res.status(201).send({id: result._id});
                }
            });
        }
    });
 };

export const userGetById = (req: Request, res: Response) => {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
        res.status(400).send({message: "invalid id syntax"});
        return;
    }
    UserModel.findById(req.params.id).then((result) => {
        if (result) {
            res.status(200).send(result) ;
        } else {
            res.status(404).send({message: "not found"});
        }
    });
 };

export const userGet = (req: Request, res: Response) => {
    UserModel.find( (err, result) => {
        if (result) {
            res.status(200).send(result) ;
        } else {
        res.status(200).send(result) ;
        }
    });
 };

export const userPut = (req: Request, res: Response) => {
     UserModel.findByIdAndUpdate(req.params.id, req.body, (err, result) => {
         if (err) {
             res.status(500).send(err);
         } else {
            res.status(200).send(result);
         }
     });
 };

export const userDelete = (req: Request, res: Response) => {
    UserModel.findByIdAndRemove(req.params.id, (err, result) => {
        if (err) { res.status(500).send(err); } else { res.status(204).send(); }
    });
 };
