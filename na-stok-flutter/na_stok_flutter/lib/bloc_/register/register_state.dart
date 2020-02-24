import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isSuccess;
  final bool isFailure;
  final bool isLoading;



  RegisterState({
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isLoading
  });

  factory RegisterState.initial() {
    return RegisterState(
      isSuccess: false,
      isFailure: false,
      isLoading: false,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isSuccess: false,
      isFailure: false,
      isLoading: true,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isSuccess: false,
      isFailure: true,
      isLoading: false,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
        isSuccess: true,
        isFailure: false,
      isLoading: false,
    );
  }

  factory RegisterState.timeout() {
    return RegisterState(
      isSuccess: false,
      isFailure: true,
      isLoading: true,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isLoading: $isLoading,
    }''';
  }
}