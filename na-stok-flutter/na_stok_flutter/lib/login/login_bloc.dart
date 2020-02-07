import 'package:na_stok_flutter/login/login.dart';
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
          await _userRepository.signInWithCredentials(event.email, event.password);
          yield LoginState.success();
        } catch (_) {
          yield LoginState.failure();
        }
    } else if (event is emailTouched) {
      yield state.update(true, state.passwordTouched);
    } else if (event is passwordTouched) {
      yield state.update(state.emailTouched, true);
    }
  }


}