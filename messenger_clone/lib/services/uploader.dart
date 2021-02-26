import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Uploader {
  String chatroomId;
  String sendBy;
  File file;
  Function addImage;

  Uploader(
      {@required this.chatroomId,
      @required this.sendBy,
      @required this.file,
      @required this.addImage});

  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'gs://messengerclone-a8ebe.appspot.com');

  Future<void> uploadFile() async {
    String ref = '$chatroomId/${sendBy}_${DateTime.now()}.png';

    try {
      await _storage.ref(ref).putFile(file);
      addImage(ref);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
