import 'dart:developer';

import 'package:chat_app/colors.dart';
import 'package:chat_app/constant.dart';
import 'package:chat_app/model/chat_model.dart';
import 'package:chat_app/provider/chat_provider.dart';
import 'package:chat_app/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgController = TextEditingController();
  ChatController chatController = ChatController();
  final ScrollController _scrolltroller = ScrollController();

  bool sendButton = false;
  String textFieldValue = '';

  late IO.Socket socket;

  @override
  void initState() {
    // _initPreferences().then((_) {
    //   setState(() {
    //     msgController = TextEditingController(
    //         text: _prefs.getString('textFieldValue') ?? '');
    //     msgController.addListener(_updateTextFieldValue);
    //   });
    // });
    // _updateTextFieldValue();
    connect();
    setUpSocketListener();
    super.initState();
  }

  // void saveText() {
  //   msgController =
  //       TextEditingController(text: _prefs.getString('textFieldValue') ?? '');
  //   msgController.addListener(_updateTextFieldValue);
  // }

  // void _updateTextFieldValue() {
  //   _prefs.setString('textFieldValue', msgController.text);
  // }
  // Future<void> _initPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }

  // void _updateTextFieldValue() {
  //   _prefs.setString('textFieldValue', msgController.text);
  // }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

// http://192.168.43.188:4000
  void connect() {
    socket = IO.io(
        'http://localhost:4000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();
    // _scrolltroller.animateTo(
    //   _scrolltroller.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => Container(
                    margin: const EdgeInsets.all(10),
                    child: Text('Connected User${chatController.connectUser}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ))),
              ),
            ),
            Expanded(
                flex: 9,
                child: Obx(
                  () => ListView.builder(
                    itemCount: chatController.chatMessages.length + 1,
                    controller: _scrolltroller,
                    itemBuilder: (context, index) {
                      if (index == chatController.chatMessages.length) {
                        return Container(
                          height: 70,
                        );
                      }
                      var currentItem = chatController.chatMessages[index];

                      return MessageItem(
                        sentByMe: currentItem.sentByMe == socket.id,
                        message: currentItem.message,
                        time: currentItem.time,
                      );
                    },
                  ),
                )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: msgController,
                  cursorColor: kPurple,
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    enabledBorder: border,
                    focusedBorder: border,
                    suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: kPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                            onPressed: () {
                              _scrolltroller.animateTo(
                                _scrolltroller.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                              sendmessage(msgController.text);
                              msgController.text = '';
                              setState(() {
                                sendButton = false;
                              });
                            },
                            icon: const Icon(Icons.send, color: Colors.white))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendmessage(String text) {
    DateTime now = DateTime.now();
    var message = {
      "message": text,
      "sentByMe": socket.id,
      "time": DateFormat('kk:mm').format(now),
    };
    socket.emit('message', message);
    chatController.chatMessages.add(ChatMessage.fromJson(message));
  }

  void setUpSocketListener() {
    socket.on('message-receive', (data) {
      log(data.toString());
      chatController.chatMessages.add(ChatMessage.fromJson(data));
    });
    socket.on('connected-user', (data) {
      log(data.toString());
      chatController.connectUser.value = data;
    });
  }
}

//  height: MediaQuery.of(context).size.height * 0.08,
              // width: MediaQuery.of(context).size.width * 0.08,