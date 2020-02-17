import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';

class Message{
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final String dateTime;
  final String tripId;

  Message(this.tripId, this.authorId, this.authorName, this.content, this.dateTime, this.id);

  Message.fromJson(Map<String, dynamic> json)
      : authorName = json['authorName'],
        authorId = json['authorId'],
        content = json['content'],
        dateTime = json['dateTime'],
        tripId = json['tripId'],
        id = json['_id'];


  String toJson() =>
      jsonEncode({
        "authorId": "$authorId",
        "authorName": "$authorName",
        "content": "$content",
        "dateTime": "$dateTime",
        "tripId": "$tripId"
      });

  ChatMessage parseToChatMessage(){
    return ChatMessage(id: id, text: this.content, user: ChatUser(name: authorName, uid: authorId), createdAt: DateTime.parse(dateTime));
  }
}