import 'package:Scholar_Chat/widget/custom_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterPage';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usercreate = FirebaseFirestore.instance.collection('users');

  String? email;
  String? username;
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
                      'Register',
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
                    onchanged: (data) {
                      username = data;
                    },
                    hint: 'Name'),
                const SizedBox(
                  height: 15,
                ),
                Custom_FormField(
                    onchanged: (data) {
                      email = data;
                    },
                    hint: 'Email'),
                const SizedBox(
                  height: 15,
                ),
                Custom_FormField(
                  obsecure: true,
                  hint: 'password',
                  onchanged: (data) {
                    password = data;
                  },
                ),
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
                        await CreateUser();
                        Navigator.pop(context);
                        show_Snackbar(
                            context, 'The account Created Successfully , try to login.');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          show_Snackbar(
                              context, 'The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          show_Snackbar(context,
                              'The account already exists for that email.');
                        }
                      } catch (e) {
                        show_Snackbar(
                          context,
                          'error',
                        );
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
                    child: const Center(child: Text('REGISTER')),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'have an account ? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
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

  void show_Snackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> CreateUser() async {
    // ignore: unused_local_variable
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      usercreate.doc(user.user!.uid).set({
        'email': user.user!.email,
        'uid': user.user!.uid,
        'username': username,
        'photo':
            'https://icon-library.com/images/default-user-icon/default-user-icon-3.jpg'
      });
    } catch (error) {
      print(error);
    }
  }
}
