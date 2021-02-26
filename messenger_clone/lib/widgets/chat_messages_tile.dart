import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/widgets/photo_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageTile extends StatefulWidget {
  String message, image, profileUrl;
  bool sendByMe;

  ChatMessageTile(
      {@required this.message,
      @required this.image,
      @required this.sendByMe,
      @required this.profileUrl});

  @override
  _ChatMessageTileState createState() => _ChatMessageTileState();
}

class _ChatMessageTileState extends State<ChatMessageTile> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: widget.sendByMe ? WrapAlignment.end : WrapAlignment.start,
      children: [
        widget.sendByMe
            ? Container()
            : Container(
                padding: EdgeInsets.only(top: 25.h, left: 5.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    widget.profileUrl,
                    height: 25.h,
                    width: 25.w,
                  ),
                ),
              ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  widget.sendByMe ? Colors.blue : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight: widget.sendByMe
                      ? Radius.circular(0)
                      : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: widget.sendByMe
                      ? Radius.circular(24)
                      : Radius.circular(0)),
            ),
            child: widget.image != ""
                ? FutureBuilder(
                    future: _buildImage(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data;
                      } else {
                        return Container(child: CircularProgressIndicator());
                      }
                    })
                : Text(
                    widget.message,
                    style: TextStyle(
                        color: widget.sendByMe ? Colors.white : Colors.black,
                        fontSize: 16.sp),
                  )),
      ],
    );
  }

  Future<Widget> _buildImage() async {
    final FirebaseStorage _storage = FirebaseStorage.instanceFor(
        bucket: 'gs://messengerclone-a8ebe.appspot.com');

    String url = await _storage
        .refFromURL('gs://messengerclone-a8ebe.appspot.com/${widget.image}')
        .getDownloadURL();

    return SizedBox(
      height: 150.h,
      width: 150.w,
      child: GestureDetector(
          child: Hero(
            tag: '$url',
            child: Image.network(url),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return PhotoPage(url: url);
            }));
          }),
    );
  }
}
