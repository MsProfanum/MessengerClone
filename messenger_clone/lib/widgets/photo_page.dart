import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoPage extends StatelessWidget {
  String url;

  PhotoPage({@required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Hero(
              tag: '$url',
              child: Image.network(url),
            ),
            onTap: () => Navigator.pop(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.save_alt,
                  color: Colors.white,
                  size: 30.w,
                ),
                onTap: _saveImage,
              )
            ],
          ),
        ],
      ),
    );
  }

  void _saveImage() async {
    final response = await http.get(url);

    final imageName = path.basename(url);
    final appDir = await pathProvider.getApplicationDocumentsDirectory();

    print(appDir);

    final localPath = path.join(appDir.path, imageName);

    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);
    print('Downloaded!');
  }
}
