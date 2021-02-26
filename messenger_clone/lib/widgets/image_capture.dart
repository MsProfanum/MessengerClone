import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_clone/services/uploader.dart';

class ImageCapture extends StatefulWidget {
  String chatroomId;
  String sendBy;
  Function addImage;

  ImageCapture(
      {@required this.chatroomId,
      @required this.sendBy,
      @required this.addImage});

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.photo_camera,
              color: Colors.blue,
            ),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.photo, color: Colors.blue),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    Uploader(
            chatroomId: widget.chatroomId,
            sendBy: widget.sendBy,
            file: selected,
            addImage: widget.addImage)
        .uploadFile();
  }
}
