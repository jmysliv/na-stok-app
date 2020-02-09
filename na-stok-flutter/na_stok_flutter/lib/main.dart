import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/authentication/authentication.dart';
import 'package:na_stok_flutter/bloc-delegate.dart';
import 'package:na_stok_flutter/login/login.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/screens/login_screen.dart';
import 'package:na_stok_flutter/screens/home_screen.dart';
import 'package:na_stok_flutter/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository)
        ..add(AppStarted()),
      child: MyApp(userRepository: userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'na-stok-app',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(userRepository: _userRepository),
              child: LoginScreen(userRepository: _userRepository),
            );
          }
          if (state is Authenticated) {
            return HomeScreen(user: state.user, userRepository: _userRepository);
          }
          else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
