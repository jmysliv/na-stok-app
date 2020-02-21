import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository{
  String token;
  static const url = "http://192.168.43.53:3000";
  UserRepository(){
    this.token = null;
  }

  Map<String, String> setUpHeaders(){
    if( this.token == null){
      return {'Content-Type': 'application/json'};
    } else {
      return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
    }
  }

  Future<void> signInWithCredentials(String email, String password) async {
    UserToAuth userToAuth = UserToAuth(email, password);
    final response = await http.post('$url/auth', body: userToAuth.toJson(), headers: setUpHeaders());
    if (response.statusCode == 201){
      this.token = jsonDecode(response.body)['accessToken'];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", this.token);
    } else {
      // If that response was not OK, throw an error.

      throw Exception('Failed to authenticate');
    }
  }

  Future<void> signUp({String email, String password, String name}) async {
    UserWithPassword userWithPassword = UserWithPassword(name, email, password);
    final response = await http.post('$url/users', body: userWithPassword.toJson(), headers: setUpHeaders());
    if (response.statusCode == 201){
      await signInWithCredentials(email, password);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to create account');
    }
  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", null);
    this.token = null;
  }

  Future<bool> isSignedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.token = prefs.getString('token');
    return this.token != null;
  }

  Future<User> getUser() async {
     final response = await http.get('$url/me', headers: setUpHeaders());
     if (response.statusCode == 200){
       User user = User.fromJson(jsonDecode(response.body));
       return user;
     } else {
        throw Exception('Failed to load user');
     }
  }

  Future<User> getUserById(String id) async{
    final response = await http.get('$url/users/$id', headers: setUpHeaders());
    if (response.statusCode == 200){
      User user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }
}