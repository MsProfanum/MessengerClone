import 'package:flutter/material.dart';
import 'package:messenger_clone/widgets/chat_messages_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypingAreaWidget extends StatelessWidget {
  TextEditingController messageTextEditingController;
  Function addMessage;

  TypingAreaWidget(
      {@required this.messageTextEditingController, @required this.addMessage});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Expanded(
          child: TextField(
            controller: messageTextEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Aa",
            ),
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
      ),
    );
  }
}
