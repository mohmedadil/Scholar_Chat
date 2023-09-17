import 'package:Scholar_Chat/pages/cubits/Login_Cubit/login_cubit.dart';
import 'package:Scholar_Chat/pages/cubits/Login_Cubit/register_cubit.dart';
import 'package:Scholar_Chat/widget/custom_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';

class RegisterScreen extends StatelessWidget {
  final usercreate = FirebaseFirestore.instance.collection('users');
  static String id = 'RegisterPage';
  String? email;
  String? username;
  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pop(context);
          isLoading = false;
        } else if (state is RegisterFailure) {
          show_Snackbar(context, state.error!);
                    isLoading = false;
        }
      },
      builder: (context, state) {
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
                          BlocProvider.of<RegisterCubit>(context).CreateUser(
                              email: email!,
                              password: password!,
                              username: username!);
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
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void show_Snackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  
}
