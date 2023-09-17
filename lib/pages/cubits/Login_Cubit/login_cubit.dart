import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  String? uid;
  Future<void> sign_in(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      uid = user.user!.uid;
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      emit(LoginFailure(error:'No user found for that email.' ));  
      } else if (e.code == 'wrong-password') {
         emit(LoginFailure(error:'Wrong password for that user.' ));  
      }
    } on Exception catch (e) {
      emit(LoginFailure(error: 'something went wrong'));
    }
  }
}
