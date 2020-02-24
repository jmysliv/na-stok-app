import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/bloc_/trip_details/trip_details.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final TripRepository tripRepository;
  final UserRepository userRepository;

  TripDetailsBloc(this.userRepository, this.tripRepository);

  @override
  TripDetailsState get initialState => InitialTrip();

  @override
  Stream<TripDetailsState> mapEventToState(TripDetailsEvent event) async* {
    if(event is InitTrip){
      try{
        Trip trip = await tripRepository.getTrip(event.tripId).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        User user = await userRepository.getUser().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        if(DateTime.parse(trip.departureDateTime).isBefore(DateTime.now())) yield OldTrip(trip);
        else if(user.id == trip.creatorId){
          if(trip.calculateFreePlaces() == 0) yield CreatorFullTrip(trip);
          else yield CreatorTrip(trip);
        } else if(trip.participants.contains(user.id)){
          yield ParticipantTrip(trip);
        } else if(trip.participantsRequests.contains(user.id)){
          yield AwaitingTrip(trip);
        } else if(trip.calculateFreePlaces() == 0){
          yield NotEnoughPlaceTrip(trip);
        } else yield NotParticipantTrip(trip);
      } catch(exception){
        if(exception is TimeoutException) yield TripFailure(exception.message);
        else yield DeletedTrip();
      }
    } else if(event is JoinTrip){
      try{
        yield LoadingTrip(event.trip);
        Trip trip = await tripRepository.getTrip(event.trip.id).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        User user = await userRepository.getUser().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        if(trip.calculateFreePlaces() > 0){
          trip.participantsRequests.add(user.id);
          yield AwaitingTrip(await updateAndGetNewOne(trip).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')));
        } else {
          yield NotEnoughPlaceTrip(trip);
        }
      }catch(exception){
        if(exception is TimeoutException) yield TripFailure(exception.message);
        else yield DeletedTrip();
      }
    } else if(event is LeaveTrip){
      try{
        yield LoadingTrip(event.trip);
        Trip trip = await tripRepository.getTrip(event.trip.id).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        User user = await userRepository.getUser().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        trip.participants.remove(user.id);
        yield NotParticipantTrip(await updateAndGetNewOne(trip).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')));
      }catch(exception){
        if(exception is TimeoutException) yield TripFailure(exception.message);
        else yield DeletedTrip();
      }
    } else if(event is AcceptSbToTrip){
      try{
        yield LoadingTrip(event.trip);
        Trip trip = await tripRepository.getTrip(event.trip.id).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        trip.participantsRequests.remove(event.acceptId);
        trip.participants.add(event.acceptId);
        if(trip.calculateFreePlaces() == 0) yield CreatorFullTrip(await updateAndGetNewOne(trip).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')));
        else yield CreatorTrip(await updateAndGetNewOne(trip).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')));
      }catch(exception){
        if(exception is TimeoutException) yield TripFailure(exception.message);
        else yield DeletedTrip();
      }
    } else if(event is DiscardSbFromTrip){
      try{
        yield LoadingTrip(event.trip);
        Trip trip = await tripRepository.getTrip(event.trip.id).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        trip.participantsRequests.remove(event.discardId);
        yield CreatorTrip(await updateAndGetNewOne(trip).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')));

      }catch(exception){
        if(exception is TimeoutException) yield TripFailure(exception.message);
        else yield DeletedTrip();
      }
    }else if(event is CancelTrip){
      try{
        tripRepository.deleteTrip(event.tripId).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        yield DeletedTrip();
      }catch(exception){
        if(exception is TimeoutException) yield TripFailure(exception.message);
        else yield DeletedTrip();
      }
    } else if(event is RefreshTrip){
      try{
        yield LoadingTrip(event.trip);
        Trip trip = await tripRepository.getTrip(event.trip.id).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        User user = await userRepository.getUser().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
        if(DateTime.parse(trip.departureDateTime).isBefore(DateTime.now())) yield OldTrip(trip);
        else if(user.id == trip.creatorId){
          if(trip.calculateFreePlaces() == 0) yield CreatorFullTrip(trip);
          else yield CreatorTrip(trip);
        } else if(trip.participants.contains(user.id)){
          yield ParticipantTrip(trip);
        } else if(trip.participantsRequests.contains(user.id)){
          yield AwaitingTrip(trip);
        } else if(trip.calculateFreePlaces() == 0){
          yield NotEnoughPlaceTrip(trip);
        } else yield NotParticipantTrip(trip);
      } catch(exception){
        if(exception is TimeoutException) yield TripFailure(exception.message);
        else yield DeletedTrip();
      }
    }
  }

  Future<Trip> updateAndGetNewOne(Trip trip) async{
    print(trip);
    await tripRepository.updateTrip(trip);
    Trip newTrip = await tripRepository.getTrip(trip.id);
    print(newTrip);
    return newTrip;
  }

}