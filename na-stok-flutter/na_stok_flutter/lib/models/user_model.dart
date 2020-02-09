import 'dart:convert';

class User {
  final String name;
  final String email;
  final String id;

  User(this.name, this.email, this.id);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        id = json['_id'];

  String toJson() =>
      jsonEncode({
        "_id": "$id",
        "name": "$name",
        "email": "$email",
      });
  @override
  String toString() => '{ _id: $id, name: $name, email: $email}';
}

class UserWithPassword{
  final String name;
  final String email;
  final String password;

  UserWithPassword(this.name, this.email, this.password);

  UserWithPassword.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'];

  String toJson() =>
      jsonEncode({
        "password": "$password",
        "name": "$name",
        "email": "$email"
      });
  @override
  String toString() => '{ password: $password, name: $name, email: $email}';
}

class UserToAuth{
  final String email;
  final String password;

  UserToAuth(this.email, this.password);

  UserToAuth.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  String toJson() =>
      jsonEncode({
        "password": "$password",
        "email": "$email"
      });
  @override
  String toString() => '{ password: $password, email: $email}';

}