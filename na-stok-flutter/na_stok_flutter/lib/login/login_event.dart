import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class emailTouched extends LoginEvent{}

class passwordTouched extends LoginEvent{}

class LoginButtonPressed extends LoginEvent{
  final String email;
  final String password;

  const LoginButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}