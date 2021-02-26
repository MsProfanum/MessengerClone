import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messenger_clone/provider_classes/searching_user.dart';
import 'package:messenger_clone/services/auth.dart';
import 'package:messenger_clone/views/home_screen.dart';
import 'package:messenger_clone/views/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ScreenUtilInit(
              designSize: Size(411, 845),
              allowFontScaling: true,
              builder: () => ChangeNotifierProvider<SearchingUser>(
                  create: (context) => SearchingUser(), child: HomeScreen()),
            );
          } else {
            return SignInScreen();
          }
        },
      ),
    );
  }
}
