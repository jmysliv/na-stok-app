import { Request, Response } from "express";
import MessageModel from "../models/messages.model";
import TripModel from "../models/trip.model";
import { ITrips } from "./../models/trip.model";
import { SocketManager } from "./../socket";

export const postMessage = (req: Request, res: Response) => {
    const message = new MessageModel(req.body);
    message.save((err, result) => {
        if (err) {
            res.status(400).send({
                message: err,
        });
        } else {
            delete req.user;
            const socketManager = SocketManager.getInstance();
            const io = socketManager.getio();
            const tripParticipants: string[] = [];
            TripModel.findById(req.body.tripId, (error, trip: ITrips) => {
                tripParticipants.push(trip.creator);
                trip.participants.forEach( (participant) => {
                    tripParticipants.push(participant);
                });
            }).then( () => {
                let socketUsers = socketManager.getSocketUsers();
                socketUsers = socketUsers.filter((socketUser) => {
                    let flag = false;
                    tripParticipants.forEach( (participant) => {
                        if (socketUser.userId === participant) {
                            flag  = true;
                        }
                    });
                    return flag;
                });
                socketUsers.forEach( (socketUser) => {
                    io.to(`${socketUser.socketId}`).emit("message", req.body);
                });
                res.status(201).send();
            });
        }
    });

};

export const getMessageByTripID = (req: Request, res: Response) => {
    MessageModel.find({tripId: req.params.id}, (err, result) => {
        if (err) {
            res.status(400).send(err);
        } else {
             res.status(200).send(result);
        }
    });
};

export const getMessages = (req: Request, res: Response) => {
    MessageModel.find( (err, result) => {
        if (err) {
            res.status(400).send(err);
        } else {
             res.status(200).send(result);
        }
    });
};

export const deleteMessageById = (req: Request, res: Response) => {
    MessageModel.findByIdAndRemove(req.params.id, (err, result) => {
        if (err) { res.status(500).send(err); } else { res.status(204).send(result); }
    });
};
