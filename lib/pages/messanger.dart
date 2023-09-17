import 'package:Scholar_Chat/models/message_model.dart';
import 'package:Scholar_Chat/pages/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';
import 'Login_screen.dart';
import 'cubits/Login_Cubit/cubit/chat_cubit.dart';

class Messanger extends StatefulWidget {
  static String id = 'Messanger';

  @override
  State<Messanger> createState() => _MessangerState();
}

class _MessangerState extends State<Messanger> {
  List<UserModel> userList = [];
  UserModel admin = UserModel('uid', '', '', '');
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var uid = ModalRoute.of(context)!.settings.arguments;
    final users = FirebaseFirestore.instance.collection('users');
    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              if (snapshot.data!.docs[i]['uid'] != uid) {
                userList.add(UserModel.fromjason(snapshot.data!.docs[i]));
              }
              if (snapshot.data!.docs[i]['uid'] == uid) {
                admin = UserModel.fromjason(snapshot.data!.docs[i]);
              }
            }
            return ModalProgressHUD(
              inAsyncCall: false,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/scholar.png',
                        height: 60,
                        width: 60,
                      ),
                      const Text('Chats'),
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
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(admin.photo),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              admin.username,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.rectangle),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                            height: 130,
                            child: ListView.separated(
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Chat_Screen.id,
                                      arguments: userList[index].uid);
                                },
                                child: BuilStory(userList[index].username,
                                    userList[index].photo),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 20,
                              ),
                              itemCount: userList.length,
                              scrollDirection: Axis.horizontal,
                            )),
                        const SizedBox(
                          height: 25,
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                BlocProvider.of<ChatCubit>(context).getmessage(
                                    sender: uid as String,
                                    reciver: userList[index].uid);
                                Navigator.pushNamed(context, Chat_Screen.id,
                                    arguments: userList[index].uid);
                              },
                              child: BuilChat(userList[index].username,
                                  userList[index].photo)),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                          itemCount: userList.length,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const ModalProgressHUD(inAsyncCall: true, child: Scaffold());
          }
        });
  }

  Widget BuilChat(String username, photo) => Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(photo),
            radius: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    const Expanded(
                        child: Text(
                      'Tap to see the messages',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(
                      width: 3,
                    ),
                    Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );

  Widget BuilStory(username, photo) => Container(
        width: 70,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(photo),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.only(
                    bottom: 5,
                    end: 5,
                  ),
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              username,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
