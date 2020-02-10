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
          yield HomeSlopes( await slopeRepository.getSlopes().timeout(const Duration(seconds: 5)));
        } catch(_){
          yield HomeFailure();
        }
      } else if(event is ShowMyProfile){
        try{
          yield HomeLoading();
          yield HomeMyProfile( await userRepository.getUser().timeout(const Duration(seconds: 5)));
        } catch(_){
          yield HomeFailure();
        }
      } else if(event is ShowTrips){
        try{
          yield HomeLoading();
          List<Trip> trips = await tripRepository.getTrips().timeout(const Duration(seconds: 5));
          yield HomeTrips(tripRepository, trips, await calculateMaxDistance(trips));
        } catch(exception){
          print(exception);
//          yield HomeFailure();
        }

      } else if (event is ShowMyTrips){
        try{
          yield HomeLoading();
          List<Trip> trips = await tripRepository.getTrips().timeout(const Duration(seconds: 5));
          trips = trips.where( (trip) {
            if(trip.creatorId == user.id) return true;
            bool flag = false;
            trip.participants.forEach( (participant) {
              if(participant == user.id) flag = true;
            });
            return flag;
          }).toList();
          
          yield HomeMyTrips(tripRepository, trips, await calculateMaxDistance(trips));
        } catch(_){
          yield HomeFailure();
        }

      }
  }
  
  Future<double> calculateMaxDistance(List<Trip> trips) async{
    double max = 0;
    for(Trip trip in trips){
      double tmp = await trip.calculateDistance().timeout(const Duration(seconds: 10));
      if(tmp> max) max = tmp;
      await trip.getAddress().timeout(const Duration(seconds: 10));
    }
    return max;
  }
}