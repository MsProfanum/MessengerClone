import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/helper_functions/sharedpref_helper.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:messenger_clone/widgets/chat_messages.dart';
import 'package:messenger_clone/widgets/image_capture.dart';
import 'package:messenger_clone/widgets/typing_area_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String username, name;
  ChatScreen(this.username, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  String myName, myProfilePic, myUsername, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();
  Stream<QuerySnapshot> messageStream;

  getMyInfoFromShareedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUsername = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getEmail();

    chatRoomId = generateChatroomIdByUsernames(widget.username, myUsername);
  }

  addImage(String imagePath) {
    var lastMessageTimestamp = DateTime.now();

    Map<String, dynamic> messageInfoMap = {
      "image": imagePath,
      "sendBy": myUsername,
      "timestamp": lastMessageTimestamp,
      "profileUrl": myProfilePic
    };

    if (messageId == "") {
      messageId = randomAlphaNumeric(12);
    }

    DatabaseMethods()
        .addMessage(chatRoomId, messageId, messageInfoMap)
        .then((value) {
      Map<String, dynamic> lastMessageInfoMap = {
        "lastMessage": "Image send",
        "lastMessageSendTimestamp": lastMessageTimestamp,
        "lastMessageSendBy": myUsername
      };

      DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
    });
  }

  addMessage(bool sendClicked) {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;

      var lastMessageTimestamp = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUsername,
        "timestamp": lastMessageTimestamp,
        "profileUrl": myProfilePic
      };

      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTimestamp": lastMessageTimestamp,
          "lastMessageSendBy": myUsername
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          messageTextEditingController.text = "";
          messageId = "";
        }
      });
    }
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  onLaunch() async {
    await getMyInfoFromShareedPreference();
    getAndSetMessages();
  }

  generateChatroomIdByUsernames(String username1, String username2) {
    if (username1.substring(0, 1).codeUnitAt(0) >
        username2.substring(0, 1).codeUnitAt(0)) {
      return "$username2\_$username1";
    } else {
      return "$username1\_$username2";
    }
  }

  @override
  void initState() {
    onLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Container(
          child: Stack(
            children: [
              ChatMessages(
                  messageStream: messageStream, myUsername: myUsername),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    ImageCapture(
                      chatroomId: chatRoomId,
                      sendBy: myUsername,
                      addImage: addImage,
                    ),
                    TypingAreaWidget(
                      messageTextEditingController:
                          messageTextEditingController,
                      addMessage: addMessage,
                    ),
                    GestureDetector(
                        onTap: () {
                          addMessage(true);
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.blue,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
