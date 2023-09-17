import 'package:Scholar_Chat/constants.dart';
import 'package:Scholar_Chat/models/message_model.dart';
import 'package:Scholar_Chat/pages/cubits/Login_Cubit/cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widget/Chat_bubble.dart';

class Chat_Screen extends StatefulWidget {
  static String id = 'chatpage';

  const Chat_Screen({super.key});

  @override
  State<Chat_Screen> createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  String? data;

  final chatcontroler = ScrollController();

  TextEditingController controller = TextEditingController();
  List<MessageModel> messageList = [];
  @override
  Widget build(BuildContext context) {
    var email = FirebaseAuth.instance.currentUser;
    var sender = email!.uid;
    var reciver = ModalRoute.of(context)!.settings.arguments as String;
    final messages = FirebaseFirestore.instance
        .collection('users')
        .doc(sender)
        .collection('chats')
        .doc(reciver)
        .collection('messages');
    final sendmessages = FirebaseFirestore.instance.collection('users');
    return ModalProgressHUD(
      inAsyncCall: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/scholar.png',
                height: 60,
                width: 60,
              ),
              const Text('Chat'),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.login_sharp))
          ],
        ),
        body: Column(children: [
          Expanded(child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              var messageList = BlocProvider.of<ChatCubit>(context).messageList;
              return ListView.builder(
                  reverse: true,
                  controller: chatcontroler,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    return messageList[index].sender == sender
                        ? Chat_bubble(
                            message: messageList[index],
                          )
                        : Chat_bubble_tofriend(message: messageList[index]);
                  });
            },
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                data = value;
              },
              controller: controller,
              onSubmitted: (value) {
                BlocProvider.of<ChatCubit>(context).sendmessage(
                    message: value, sender: sender, reciver: reciver);
                controller.clear();
                chatcontroler.animateTo(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      sendmessages
                          .doc(sender)
                          .collection('chats')
                          .doc(reciver)
                          .collection('messages')
                          .add({
                        'body': data,
                        'CreatedAt': DateTime.now(),
                        'sender': sender,
                        'reciver': reciver
                      });
                      sendmessages
                          .doc(reciver)
                          .collection('chats')
                          .doc(sender)
                          .collection('messages')
                          .add({
                        'body': data,
                        'CreatedAt': DateTime.now(),
                        'sender': sender,
                        'reciver': reciver,
                      });
                      controller.clear();
                      chatcontroler.animateTo(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: kPrimaryColor,
                    ),
                  ),
                  hintText: 'Send Message',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: kPrimaryColor))),
            ),
          )
        ]),
      ),
    );
  }
}
