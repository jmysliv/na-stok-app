import 'dart:async';

import 'package:na_stok_flutter/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/slope_repository.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final UserRepository userRepository;
  final SlopeRepository slopeRepository;
  final TripRepository tripRepository;
  final User user;
  HomeBloc(this.userRepository, this.slopeRepository, this.tripRepository, this.user);

  @override
  HomeState get initialState => HomeLoading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
      if(event is ShowSlopes){
        yield HomeLoading();
        try{
          yield HomeSlopes( await slopeRepository.getSlopes().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')));
        } catch(exception){
          if(exception is TimeoutException) yield HomeFailure(exception.message);
          else yield HomeFailure(exception.toString());
        }
      } else if(event is ShowMyProfile){
        try{
          yield HomeLoading();
          List<Trip> trips = await tripRepository.getTrips().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
          yield HomeMyProfile( await userRepository.getUser().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')), trips);
        } catch(exception){
          if(exception is TimeoutException) yield HomeFailure(exception.message);
          else yield HomeFailure(exception.toString());
        }
      } else if(event is ShowTrips){
        try{
          yield HomeLoading();
          List<Trip> trips = await tripRepository.getTrips().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
          yield HomeTrips(tripRepository, trips, await calculateMaxDistance(trips));
        } catch(exception){
          if(exception is TimeoutException) yield HomeFailure(exception.message);
          else yield HomeFailure(exception.toString());
        }

      } else if (event is ShowMyTrips){
        try{
          yield HomeLoading();
          List<Trip> trips = await tripRepository.getTrips().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
          trips = trips.where( (trip) {
            if(trip.creatorId == user.id) return true;
            bool flag = false;
            trip.participants.forEach( (participant) {
              if(participant == user.id) flag = true;
            });
            return flag;
          }).toList();
          
          yield HomeMyTrips(tripRepository, trips, await calculateMaxDistance(trips));
        } catch(exception){
          if(exception is TimeoutException) yield HomeFailure(exception.message);
          else yield HomeFailure(exception.toString());
        }

      }
  }
  
  Future<double> calculateMaxDistance(List<Trip> trips) async{
    double max = 0;
    for(Trip trip in trips){
      double tmp = await trip.calculateDistance().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException("Żeby aplikacja działała poprawnie, proszę włączyć lokalizację w swoim telefonie, zezwolić aplikacji na dostęp do niej i uruchomić ponownie."));
      if(tmp> max) max = tmp;
      await trip.getAddress().timeout(const Duration(seconds: 10));
    }
    return max;
  }
}