import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TripRepository{
  static const url = "http://46.101.198.229:3000";
  UserRepository _userRepository;
  TripRepository(this._userRepository);

  Future<List<Trip>> getTrips() async {
    final response = await http.get('$url/trips', headers: _userRepository.setUpHeaders());
    if(response.statusCode == 200){
      List<Trip> trips = (jsonDecode(response.body) as List).map( (e) => Trip.fromJson(e)).toList();
      return trips;
    } else {
      throw Exception('Failed to get trips');
    }
  }

  Future<Trip> getTrip(String id) async {
    final response = await http.get('$url/trips/$id', headers: _userRepository.setUpHeaders());
    if(response.statusCode == 200){
      Trip trip = Trip.fromJson(jsonDecode(response.body));
      await trip.getAddress();
      await trip.getParticipantList(_userRepository);
      await trip.getParticipantRequestList(_userRepository);
      return trip;
    } else {
      throw Exception('Failed to get trips');
    }
  }

  Future<void> insertTrip(Trip trip) async {
    final response = await http.post('$url/trips', body: trip.toJson(), headers: _userRepository.setUpHeaders());
    if (response.statusCode == 201){
      return;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to insert Trip');
    }
  }

  Future<void> updateTrip(Trip trip) async{
    final response = await http.put('$url/trips/${trip.id}', body: trip.toJson(), headers: _userRepository.setUpHeaders());
    if( response.statusCode == 200){
      return;
    } else {
      throw Exception('Failed to update Trip');
    }
  }

  Future<void> deleteTrip(String id) async{
    final response = await http.delete('$url/trips/${id}', headers: _userRepository.setUpHeaders());
    if(response.statusCode == 204){
      return;
    } else {
      throw Exception('Failed to delete Trip');
    }
  }
}