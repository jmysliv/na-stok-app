import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool emailTouched;
  final bool passwordTouched;
  final bool nameTouched;
  final bool isSuccess;
  final bool isFailure;


  RegisterState({
    @required this.emailTouched,
    @required this.passwordTouched,
    @required this.nameTouched,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory RegisterState.initial() {
    return RegisterState(
      emailTouched: false,
      passwordTouched: false,
      nameTouched: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      emailTouched: true,
      passwordTouched: true,
      nameTouched: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      emailTouched: true,
      passwordTouched: true,
      nameTouched: true,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
        emailTouched: true,
        passwordTouched: true,
        nameTouched: true,
        isSuccess: true,
        isFailure: false,
    );
  }

 RegisterState update( bool emailTouched, bool passwordTouched, bool nameTouched){
    return RegisterState(
      emailTouched: emailTouched,
      passwordTouched: passwordTouched,
      nameTouched: nameTouched,
      isSuccess: false,
      isFailure: false,
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
    }''';
  }
}