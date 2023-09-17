import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../../models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<MessageModel> messageList = [];

  final sendmessages = FirebaseFirestore.instance.collection('users');
  final messages = FirebaseFirestore.instance.collection('users');
  void sendmessage(
      {required String message,
      required String sender,
      required String reciver}) {
    try {
      sendmessages
          .doc(sender)
          .collection('chats')
          .doc(reciver)
          .collection('messages')
          .add({
        'body': message,
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
        'body': message,
        'CreatedAt': DateTime.now(),
        'sender': sender,
        'reciver': reciver,
      });
    } on Exception catch (e) {}
  }

  void getmessage({required String sender, required String reciver}) {
    messages
        .doc(sender)
        .collection('chats')
        .doc(reciver)
        .collection('messages')
        .orderBy('CreatedAt', descending: true)
        .snapshots()
        .listen((event) {
      messageList.clear();
      for (var doc in event.docs) {
        messageList.add(MessageModel.fromjason(doc));
      }
      emit(ChatSuccess(messages: messageList));
    });
  }
}
// List<MessageModel> messageList = [];
//           if (snapshot.hasData) {
//             messageList = [];
//             for (int i = 0; i < snapshot.data!.docs.length; i++) {
//               messageList.add(MessageModel.fromjason(snapshot.data!.docs[i]));
//             }