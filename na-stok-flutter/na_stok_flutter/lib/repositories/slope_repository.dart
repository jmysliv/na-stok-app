import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SlopeRepository{
  static const url = "http://46.101.198.229:3000";
  UserRepository _userRepository;
  SlopeRepository(this._userRepository);

  Future<List<Slope>> getSlopes() async {
    final response = await http.get('$url/slopes', headers: _userRepository.setUpHeaders());
    if(response.statusCode == 200){
      List<Slope> slopes = (jsonDecode(response.body) as List).map( (e) => Slope.fromJson(e)).toList();
      return slopes;
    } else {
      throw Exception('Failed to get slopes');
    }
  }
}