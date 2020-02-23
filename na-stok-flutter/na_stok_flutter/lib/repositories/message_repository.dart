import 'package:na_stok_flutter/models/message_model.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageRepository{
  static const url = "http://46.101.198.229:3000";
  UserRepository _userRepository;
  MessageRepository(this._userRepository);

  Future<List<Message>> getMessageByTripId(String id) async {
    final response = await http.get('$url/messages/$id', headers: _userRepository.setUpHeaders());
    if(response.statusCode == 200){
      List<Message> messages = (jsonDecode(response.body) as List).map( (e) => Message.fromJson(e)).toList();
      return messages;
    } else {
      throw Exception('Failed to get messages');
    }
  }

  Future<void> postMessage(Message message) async {
    final response = await http.post('$url/messages', body: message.toJson(), headers: _userRepository.setUpHeaders());
    if (response.statusCode == 201){
      return;
    } else {
      print(response.body);
      throw Exception('Failed to insert message');
    }
  }
}