import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable{
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String name;

  const Submitted({
    @required this.email,
    @required this.password,
    @required this.name,
  });

  @override
  List<Object> get props => [email, password, name];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password , name: $name}';
  }
}