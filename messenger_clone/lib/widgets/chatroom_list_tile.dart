import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:messenger_clone/views/chat_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage;
  final String chatRoomId;
  final String myUsername;

  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profileUrl = "", username = "", name = "";

  getUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot query = await DatabaseMethods().getUserInfo(username);
    name = query.docs[0]["name"];
    profileUrl = query.docs[0]["profileUrl"];
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              profileUrl,
              height: 40.h,
              width: 40.w,
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.sp),
                ),
                Text(
                  widget.lastMessage,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 24.w,
          )
        ],
      ),
    );
  }
}
