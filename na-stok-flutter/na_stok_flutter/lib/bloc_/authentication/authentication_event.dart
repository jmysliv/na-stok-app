
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable{
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}
class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class ErrorOccurred extends AuthenticationEvent{
  final String errorMessage;

  const ErrorOccurred({
    @required this.errorMessage
  });

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'ErrorOccured { error: $errorMessage }';
  }
}