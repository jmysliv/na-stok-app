declare namespace Express {
    export interface Request {
       user?: {
         _id: string;
         email: string;
         password: string;
         name: string;
       };
    }
 }