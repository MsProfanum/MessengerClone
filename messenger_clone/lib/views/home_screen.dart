import 'package:flutter/material.dart';
import 'package:messenger_clone/helper_functions/sharedpref_helper.dart';
import 'package:messenger_clone/provider_classes/searching_user.dart';
import 'package:messenger_clone/services/auth.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:messenger_clone/views/sign_in_screen.dart';
import 'package:messenger_clone/widgets/home_screen_custom_widgets.dart';
import 'package:messenger_clone/widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream usersStream, chatRoomsStream;
  String myUsername;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  @override
  void initState() {
    generateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchingUserProvider =
        Provider.of<SearchingUser>(context, listen: false);

    onSearchButtonClick() async {
      setState(() {
        searchingUserProvider.setSearching(true);
      });
      usersStream = await DatabaseMethods()
          .getUserByUsername(searchUsernameEditingController.text);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Messenger Clone"),
        actions: [
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Icon(Icons.exit_to_app),
            ),
            onTap: () => AuthMethods().signOut().then((s) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            }),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SearchbarWidget(
              searchUsernameEditingController: searchUsernameEditingController,
              onSearchButtonClick: onSearchButtonClick,
            ),
            searchingUserProvider.isSearching
                ? searchUsersList(usersStream, myUsername)
                : chatRoomsList(chatRoomsStream, myUsername),
          ],
        ),
      ),
    );
  }

  generateData() async {
    await generateUsername();
    generateChatrooms();
  }

  generateUsername() async {
    myUsername = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  generateChatrooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }
}
