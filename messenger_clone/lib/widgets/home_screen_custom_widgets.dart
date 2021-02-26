import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:messenger_clone/views/chat_screen.dart';
import 'package:messenger_clone/widgets/chatroom_list_tile.dart';

Widget searchUsersList(Stream<dynamic> usersStream, String myUsername) {
  return Expanded(
    child: StreamBuilder(
        stream: usersStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return searchListUserTile(
                        ds.data()["profileUrl"],
                        ds.data()["name"],
                        ds.data()["username"],
                        ds.data()["email"],
                        context,
                        myUsername);
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        }),
  );
}

Widget searchListUserTile(String profileUrl, String name, String username,
    String email, context, String myUsername) {
  return GestureDetector(
    onTap: () {
      var chatRoomId = generateChatroomIdByUsernames(myUsername, username);
      Map<String, dynamic> chatRoomInfoMap = {
        "users": [myUsername, username]
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ChatScreen(username, name)));
    },
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            profileUrl,
            height: 40,
            width: 40,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(),
            ),
            Text(email, style: TextStyle())
          ],
        ),
      ],
    ),
  );
}

generateChatroomIdByUsernames(String username1, String username2) {
  if (username1.substring(0, 1).codeUnitAt(0) >
      username2.substring(0, 1).codeUnitAt(0)) {
    return "$username2\_$username1";
  } else {
    return "$username1\_$username2";
  }
}

Widget chatRoomsList(Stream chatRoomsStream, String myUsername) {
  return Expanded(
    child: StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ChatRoomListTile(
                      ds.data()["lastMessage"], ds.id, myUsername);
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    ),
  );
}
