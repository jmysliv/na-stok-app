import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool emailTouched;
  final bool passwordTouched;
  final bool nameTouched;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;



  RegisterState({
    @required this.emailTouched,
    @required this.passwordTouched,
    @required this.nameTouched,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isLoading
  });

  factory RegisterState.initial() {
    return RegisterState(
      emailTouched: false,
      passwordTouched: false,
      nameTouched: false,
      isSuccess: false,
      isFailure: false,
      isLoading: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      emailTouched: true,
      passwordTouched: true,
      nameTouched: true,
      isSuccess: false,
      isFailure: false,
      isLoading: true,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      emailTouched: true,
      passwordTouched: true,
      nameTouched: true,
      isSuccess: false,
      isFailure: true,
      isLoading: false,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
        emailTouched: true,
        passwordTouched: true,
        nameTouched: true,
        isSuccess: true,
        isFailure: false,
      isLoading: false,
    );
  }

  factory RegisterState.timeout() {
    return RegisterState(
      emailTouched: true,
      passwordTouched: true,
      nameTouched: true,
      isSuccess: false,
      isFailure: true,
      isLoading: true,
    );
  }

 RegisterState update( bool emailTouched, bool passwordTouched, bool nameTouched){
    return RegisterState(
      emailTouched: emailTouched,
      passwordTouched: passwordTouched,
      nameTouched: nameTouched,
      isSuccess: false,
      isFailure: false,
      isLoading: this.isLoading,
    );
 }

  @override
  String toString() {
    return '''RegisterState {
      emailTouched: $emailTouched,
      passwordTouched: $passwordTouched,
      nameTouched: $nameTouched,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isLoading: $isLoading,
    }''';
  }
}