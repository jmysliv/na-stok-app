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
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
        yield LoginLoading();
        try {
          await _userRepository.signInWithCredentials(event.email, event.password);
          yield LoginSuccess();
        } catch (error) {
          yield LoginFailure(error: error);
        }
    }
  }
  

}