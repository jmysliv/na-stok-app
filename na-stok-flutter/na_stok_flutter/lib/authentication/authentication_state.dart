
import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/user_model.dart';

abstract class AuthenticationState extends Equatable{
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState{}

class Authenticated extends AuthenticationState{
  final User user;
  const Authenticated(this.user);
  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { user: $user }';
}

class Unauthenticated extends AuthenticationState {}