import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool emailTouched;
  final bool passwordTouched;
  final bool isSuccess;
  final bool isFailure;


  LoginState({
    @required this.emailTouched,
    @required this.passwordTouched,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory LoginState.initial() {
    return LoginState(
      emailTouched: false,
      passwordTouched: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      emailTouched: true,
      passwordTouched: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      emailTouched: true,
      passwordTouched: true,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory LoginState.success() {
    return LoginState(
      emailTouched: true,
      passwordTouched: true,
      isSuccess: true,
      isFailure: false,
    );
  }

  LoginState update( bool emailTouched, bool passwordTouched){
    return LoginState(
      emailTouched: emailTouched,
      passwordTouched: passwordTouched,
      isSuccess: false,
      isFailure: false,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      emailTouched: $emailTouched,
      passwordTouched: $passwordTouched,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}