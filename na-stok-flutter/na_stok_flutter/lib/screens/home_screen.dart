import 'package:na_stok_flutter/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/home/home.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/slope_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/screens/myProfile_screen.dart';
import 'package:na_stok_flutter/screens/slopes_screen.dart';
import 'package:na_stok_flutter/screens/loading_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final UserRepository _userRepository;
  final SlopeRepository slopeRepository ;

  HomeScreen({Key key, @required this.user, UserRepository userRepository})
      : _userRepository = userRepository,
        slopeRepository = SlopeRepository(userRepository),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(_userRepository, slopeRepository)
              ..add(ShowSlopes()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state){
              if(state is HomeSlopes) {
                return SlopesScreen(userRepository: _userRepository, slopes: state.slopes, maxSnow: state.maxSnow());
              } else if (state is HomeMyProfile){
                return MyProfileScreen(user: state.user, userRepository: _userRepository);
              } else if(state is HomeLoading){
                  return LoadingScreen();
              } else{
                  BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred());
                  return LoadingScreen();
              }
        }
      ));
    }
}