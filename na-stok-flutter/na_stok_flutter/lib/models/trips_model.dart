import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';

class Trip {
  final String id;
  final String creatorId;
  final String departureDateTime;
  final int maxParticipants;
  final int prize;
  final List<String> participants;
  final List<String> participantsRequests;
  final String slope;
  final double latitude;
  final double longitude;
  double distance;
  String address;
  List<User> participantUsers = List<User>();
  List<User> participantRequestUsers = List<User>();

  Trip(this.longitude, this.latitude, this.slope, this.participantsRequests, this.prize, this.maxParticipants, this.participants, this.departureDateTime, this.creatorId, this.id);

  Trip.fromJson(Map<String, dynamic> json)
      : creatorId = json['creator'],
        id = json['_id'],
        departureDateTime = json['departureDateTime'],
        maxParticipants = json['maxParticipants'],
        prize = json['prize'],
        slope = json['slope'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        participants = (json['participants'] == null) ? [] : new List<String>.from(json['participants']),
        participantsRequests = (json['participantsRequest'] == null) ? [] : new List<String>.from(json['participantsRequest']),
        distance = 0,
        address = "unsetted";


  String toJson() =>
      jsonEncode({
        "creator": "$creatorId",
        "departureDateTime": "$departureDateTime",
        "maxParticipants": maxParticipants,
        "prize": prize,
        "participants": participants,
        "participantsRequest": participantsRequests,
        "slope": "$slope",
        "latitude": latitude,
        "longitude": longitude
      });

  Future<double> calculateDistance(Position position) async {
    double distanceInMeters = await Geolocator().distanceBetween(position.latitude, position.longitude, latitude, longitude);
    this.distance = distanceInMeters.roundToDouble()/1000;
    return distanceInMeters.roundToDouble()/1000;
  }

  int calculateFreePlaces(){
    return maxParticipants - participants.length;
  }

  Future<String> getAddress() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(latitude, longitude);
    Placemark placeMark  = placemark[0];
    String street = placeMark.thoroughfare;
    String number = placeMark.subThoroughfare;
    String locality = placeMark.locality;
    String subLocality = placeMark.subLocality;
    String postalCode = placeMark.postalCode;
    String address = "$street $number, ${subLocality}, ${locality}, ${postalCode}";
    this.address = address;
    return address;
  }

  Future<List<User>> getParticipantList(UserRepository userRepository) async{
    List<User> participantUsers = List<User>();
    User creator = await userRepository.getUserById(this.creatorId);
    participantUsers.add(creator);
    for(String participantId in this.participants){
      User user = await userRepository.getUserById(participantId);
      participantUsers.add(user);
    }
    this.participantUsers = participantUsers;
    return participantUsers;
  }

  Future<List<User>> getParticipantRequestList(UserRepository userRepository) async{
    List<User> participantUsers = List<User>();
    for(String participantId in this.participantsRequests){
      User user = await userRepository.getUserById(participantId);
      participantUsers.add(user);
    }
    this.participantRequestUsers = participantUsers;
    return participantUsers;
  }

  @override
  String toString() => '{ _id: $id, creatorId: $creatorId, departuredateTime: $departureDateTime, maxParticipants: $maxParticipants, prize: $prize,'
      'participants: $participants, participantsrequests: $participantsRequests, slope: $slope, latitude: $latitude, longitude: $longitude}';
}