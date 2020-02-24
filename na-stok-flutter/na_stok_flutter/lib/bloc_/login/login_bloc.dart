import 'dart:async';

import 'package:na_stok_flutter/bloc_/login/login.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
        yield LoginState.loading();
        try {
          await _userRepository.signInWithCredentials(event.email, event.password).timeout(const Duration(seconds: 10));
          yield LoginState.success();
        } catch (exception) {
          if(exception is TimeoutException) yield LoginState.timeout();
          else yield LoginState.failure();
        }
    }
  }


}