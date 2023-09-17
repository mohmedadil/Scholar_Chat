import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  Future<void> CreateUser(
      {required String email,
      required String password,
      required String username}) async {
    final usercreate = FirebaseFirestore.instance.collection('users');
    emit(RegisterLoading());

    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      usercreate.doc(user.user!.uid).set({
        'email': user.user!.email,
        'uid': user.user!.uid,
        'username': username,
        'photo':
            'https://icon-library.com/images/default-user-icon/default-user-icon-3.jpg'
      });
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(error: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(
            error: 'The account already exists for that email.'));
      } else {
        emit(RegisterFailure(error: 'email or password bad format'));
      }
    } on Exception catch (error) {
      RegisterFailure(error: 'something went wrong' '$error');
    }
  }
}
