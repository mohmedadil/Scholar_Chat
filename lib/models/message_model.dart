// ignore_for_file: unused_import

import 'package:flutter/material.dart';
class MessageModel {
  final String body;
  final String sender;
  final String reciver;

  MessageModel(this.body, this.sender, this.reciver);

  factory MessageModel.fromjason(jsondata) {
    return MessageModel(
        jsondata['body'], jsondata['sender'], jsondata['reciver']);
  }
}

class UserModel {
   String uid;
   String photo;
   String username;
   String email;

  UserModel(this.uid, this.photo, this.username, this.email);
  factory UserModel.fromjason(jsondata) {
    return UserModel(jsondata['uid'], jsondata['photo'], jsondata['username'],
        jsondata['email']);
  }
}
