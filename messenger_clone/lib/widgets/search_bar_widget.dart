import 'package:flutter/material.dart';
import 'package:messenger_clone/provider_classes/searching_user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchbarWidget extends StatefulWidget {
  TextEditingController searchUsernameEditingController;
  Function onSearchButtonClick;

  SearchbarWidget(
      {@required this.searchUsernameEditingController,
      @required this.onSearchButtonClick});
  @override
  _SearchbarWidgetState createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends State<SearchbarWidget> {
  @override
  Widget build(BuildContext context) {
    final searchingUserProvider = Provider.of<SearchingUser>(context);

    return Row(
      children: [
        searchingUserProvider.isSearching
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    searchingUserProvider.setSearching(false);
                    widget.searchUsernameEditingController.text = "";
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Icon(Icons.arrow_back),
                ),
              )
            : Container(),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.searchUsernameEditingController,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "search username"),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      if (widget.searchUsernameEditingController.text != "") {
                        widget.onSearchButtonClick();
                      }
                    },
                    child: Icon(Icons.search)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
