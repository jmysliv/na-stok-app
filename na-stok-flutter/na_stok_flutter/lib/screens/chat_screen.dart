import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:na_stok_flutter/models/message_model.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/message_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/screens/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatScreen extends StatefulWidget{
  final String tripId;
  final UserRepository userRepository;
  final MessageRepository messageRepository;


  ChatScreen({Key key, @required this.tripId, UserRepository userRepository})
      : userRepository = userRepository,
        messageRepository = MessageRepository(userRepository),
        super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState(userRepository, messageRepository, tripId);
}

class ChatScreenState extends State<ChatScreen>{
  final String tripId;
  final UserRepository userRepository;
  final MessageRepository messageRepository;
  User user;
  List<Message> messages;
  List<ChatMessage> chatMessages = List<ChatMessage>();
  IO.Socket socket;

  ChatScreenState(this.userRepository, this.messageRepository, this.tripId);

  @override
  void initState() {
    init();
    socket = IO.io('http://46.101.198.229:3000/?token=${userRepository.token}', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.on('message', (jsonData) {
      Message newMessage = Message.fromJson(jsonData);
      this.setState(() {
        messages.add(newMessage);
        chatMessages.add(newMessage.parseToChatMessage());
      });
      socket.connect();
    });
    super.initState();
  }

  void init() async{
    user = await userRepository.getUser();
    messages = await messageRepository.getMessageByTripId(tripId);
    for(Message m in messages){
      chatMessages.add(m.parseToChatMessage());
    }
    this.setState( () {});
  }

  void onSend(ChatMessage message) async {
    Message newMessage = Message(tripId, user.id, user.name, message.text, message.createdAt.add(Duration(hours: 1)).toIso8601String(), "id");
    await messageRepository.postMessage(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    if(user == null || socket == null) {
      return LoadingScreen();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Chat uczestników wyjazdu"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.of(context).pop();
                  socket.disconnect();
                }
            ),
          ),
          body: DashChat(
            user: ChatUser(uid: user.id, name: user.name),
            messages: chatMessages,
            inputDecoration: InputDecoration(
              hintText: "Napisz wiadomość...",
              border: InputBorder.none,
            ),
            onSend: onSend,
            avatarBuilder: (ChatUser chatUser) {
              return Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(chatUser.name, style: TextStyle( fontFamily: 'Roboto', color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.bold,), overflow: TextOverflow.ellipsis,),
              );
            },
            dateFormat: initializeDate(),
            timeFormat: DateFormat.Hm(),
          )
      );
    }

  }

  DateFormat initializeDate(){
    initializeDateFormatting('pl', null);
    return DateFormat.yMMMMEEEEd('pl');

  }
}
