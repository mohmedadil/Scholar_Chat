import 'package:Scholar_Chat/pages/Register_Screen.dart';
import 'package:Scholar_Chat/pages/messanger.dart';
import 'package:Scholar_Chat/widget/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginPage';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String? email;
  String? uid;
  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await sign_in();
                        Navigator.pushNamed(context, Messanger.id,
                            arguments: uid);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          show_Snackbar(
                              context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          show_Snackbar(context,
                              'Wrong password for that user.');
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
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
                    )
                  ],
                ),
              ],
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