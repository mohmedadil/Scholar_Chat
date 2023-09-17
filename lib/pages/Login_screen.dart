import 'package:Scholar_Chat/pages/Register_Screen.dart';
import 'package:Scholar_Chat/pages/cubits/Login_Cubit/login_cubit.dart';
import 'package:Scholar_Chat/pages/messanger.dart';
import 'package:Scholar_Chat/widget/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import 'cubits/Login_Cubit/cubit/chat_cubit.dart';

class LoginScreen extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  static String id = 'LoginPage';
  String? email;
  String? uid;
  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          uid = BlocProvider.of<LoginCubit>(context).uid;

          Navigator.pushNamed(context, Messanger.id, arguments: uid);
          isLoading = false;
        } else if (state is LoginFailure) {
          show_Snackbar(context, state.error.toString());
          isLoading = false;

        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: formkey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 75,
                  ),
                  Image.asset(
                    'assets/images/scholar.png',
                    height: 100,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scholar Chat',
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontFamily: 'Pacifico'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Custom_FormField(
                      hint: 'Email',
                      onchanged: (data) {
                        email = data;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Custom_FormField(
                      obsecure: true,
                      hint: 'password',
                      onchanged: (data) {
                        password = data;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        BlocProvider.of<LoginCubit>(context)
                            .sign_in(email: email!, password: password!);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: Text('LOGIN')),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account ? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterScreen.id);
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0XffC7EDE6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sign_in() async {
    // ignore: unused_local_variable
    final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    uid = user.user!.uid;
  }
}

void show_Snackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
