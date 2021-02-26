import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/widgets/chat_messages_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessages extends StatefulWidget {
  Stream messageStream;
  String myUsername;

  ChatMessages({@required this.messageStream, @required this.myUsername});

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 70.h, top: 16.h),
              itemCount: snapshot.data.docs.length,
              reverse: true,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return ChatMessageTile(
                    message: ds.data()["message"] ?? "",
                    image: ds.data()["image"] ?? "",
                    sendByMe: widget.myUsername == ds.data()["sendBy"],
                    profileUrl: ds.data()["profileUrl"]);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
