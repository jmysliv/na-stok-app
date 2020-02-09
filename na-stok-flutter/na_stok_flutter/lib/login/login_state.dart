import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool emailTouched;
  final bool passwordTouched;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;


  LoginState({
    @required this.emailTouched,
    @required this.passwordTouched,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isLoading
  });

  factory LoginState.initial() {
    return LoginState(
      emailTouched: false,
      passwordTouched: false,
      isSuccess: false,
      isFailure: false,
      isLoading: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      emailTouched: true,
      passwordTouched: true,
      isSuccess: false,
      isFailure: false,
      isLoading: true,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      emailTouched: true,
      passwordTouched: true,
      isSuccess: false,
      isFailure: true,
      isLoading: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      emailTouched: true,
      passwordTouched: true,
      isSuccess: true,
      isFailure: false,
      isLoading: false,
    );
  }

  factory LoginState.timeout(){
    return LoginState(
      emailTouched: true,
      passwordTouched: true,
      isSuccess: false,
      isFailure: true,
      isLoading: true,
    );
  }

  LoginState update( bool emailTouched, bool passwordTouched){
    return LoginState(
      emailTouched: emailTouched,
      passwordTouched: passwordTouched,
      isSuccess: false,
      isFailure: false,
      isLoading: this.isLoading,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      emailTouched: $emailTouched,
      passwordTouched: $passwordTouched,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isLoading: $isLoading,
    }''';
  }
}