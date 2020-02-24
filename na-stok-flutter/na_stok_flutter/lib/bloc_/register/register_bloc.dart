import 'dart:async';
import 'package:na_stok_flutter/bloc_/register/register.dart';
import 'package:meta/meta.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.initial();

  @override
  Stream<RegisterState> mapEventToState(
      RegisterEvent event,
      ) async* {
   if (event is Submitted){
      yield RegisterState.loading();
      try {
        await _userRepository.signUp(
          email: event.email,
          password: event.password,
          name: event.name
        ).timeout(const Duration(seconds: 10));
        yield RegisterState.success();
      } catch (exception) {
        if(exception is TimeoutException) yield RegisterState.timeout();
        else yield RegisterState.failure();
      }
    }
  }

}