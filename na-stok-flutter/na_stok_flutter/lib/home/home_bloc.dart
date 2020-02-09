import 'package:na_stok_flutter/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:na_stok_flutter/repositories/slope_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final UserRepository userRepository;
  final SlopeRepository slopeRepository;
  HomeBloc(this.userRepository, this.slopeRepository);

  @override
  HomeState get initialState => HomeLoading();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
      if(event is ShowSlopes){
        yield HomeLoading();
        try{
          yield HomeSlopes( await slopeRepository.getSlopes());
        } catch(_){
          yield HomeFailure();
        }
      } else if(event is ShowMyProfile){
        try{
          yield HomeLoading();
          yield HomeMyProfile( await userRepository.getUser());
        } catch(_){
          yield HomeFailure();
        }
      } else if(event is ShowTrips){
        yield HomeLoading();
        yield HomeTrips();
      } else if (event is ShowMyTrips){
        yield HomeLoading();
        yield HomeMyTrips();
      }
  }
}