
import 'package:na_stok_flutter/models/user_model.dart';

class UserRepository{
  String token;
  UserRepository(){
    this.token = null;
  }
  Future<void> signInWithCredentials(String email, String password) async {
    this.token = email;
    return await true;
  }

  Future<void> signUp({String email, String password, String name}) async {
    signInWithCredentials(email, password);
    return await true;
  }

  Future<void> signOut() async {
    this.token = null;
    return await true;
  }

  Future<bool> isSignedIn() async {
    return await this.token != null;
  }

  Future<User> getUser() async {
     User user = User(this.token, this.token, 'id');
     return await user;
  }
}