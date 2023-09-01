import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/message_model.dart';

class Chat_bubble extends StatelessWidget {
  final MessageModel message;
  const Chat_bubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32),
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32))),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            message.body,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Chat_bubble_tofriend extends StatelessWidget {
  final MessageModel message;
  const Chat_bubble_tofriend({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            color: Color(0xff006D84),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32))),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            message.body,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
