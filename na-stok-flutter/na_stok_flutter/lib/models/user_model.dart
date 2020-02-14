import 'dart:collection';
import 'dart:convert';

import 'package:na_stok_flutter/models/trips_model.dart';

class User {
  final String name;
  final String email;
  final String id;

  User(this.name, this.email, this.id);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        id = json['_id'];

  String toJson() =>
      jsonEncode({
        "_id": "$id",
        "name": "$name",
        "email": "$email",
      });
  @override
  String toString() => '{ _id: $id, name: $name, email: $email}';

  int calculateTrips(List<Trip> trips){
    int counter = 0;
    trips.forEach( (trip) {
      if(trip.creatorId == this.id) counter ++;
      trip.participants.forEach( (participant) {
        if(participant == this.id) counter ++;
      });
    });
    return counter;
  }

  int calculateCreator(List<Trip> trips){
    int counter = 0;
    trips.forEach( (trip) {
      if(trip.creatorId == this.id) counter ++;
    });
    return counter;
  }

  String favouriteSlope(List<Trip> trips){
    HashMap<String, int> slopesCounter = HashMap<String, int>();
    trips.forEach( (trip) {
      if(trip.creatorId == this.id) {
        slopesCounter.update(trip.slope, (int value) => value + 1, ifAbsent: () => 1);
      }
      trip.participants.forEach( (participant) {
        if(participant == this.id) {
          slopesCounter.update(trip.slope, (int value) => value + 1, ifAbsent: () => 1);
        }
      });
    });
    String favourite = "Brak";
    int max = 0;
    slopesCounter.forEach( (String key, int value){
      print("$key : $value");
      if(value > max) {
        max = value;
        favourite = key;
      }
    });
    return favourite;
  }
}

class UserWithPassword{
  final String name;
  final String email;
  final String password;

  UserWithPassword(this.name, this.email, this.password);

  UserWithPassword.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'];

  String toJson() =>
      jsonEncode({
        "password": "$password",
        "name": "$name",
        "email": "$email"
      });
  @override
  String toString() => '{ password: $password, name: $name, email: $email}';
}

class UserToAuth{
  final String email;
  final String password;

  UserToAuth(this.email, this.password);

  UserToAuth.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  String toJson() =>
      jsonEncode({
        "password": "$password",
        "email": "$email"
      });
  @override
  String toString() => '{ password: $password, email: $email}';

}