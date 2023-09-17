import 'package:Scholar_Chat/pages/Login_screen.dart';
import 'package:Scholar_Chat/pages/Register_Screen.dart';
import 'package:Scholar_Chat/pages/chat_screen.dart';
import 'package:Scholar_Chat/pages/cubits/Login_Cubit/login_cubit.dart';
import 'package:Scholar_Chat/pages/cubits/Login_Cubit/register_cubit.dart';
import 'package:Scholar_Chat/pages/messanger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:Scholar_Chat/pages/cubits/Login_Cubit/cubit/chat_cubit.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        routes: {
          RegisterScreen.id: (context) => RegisterScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          Chat_Screen.id: (context) => Chat_Screen(),
          Messanger.id: (context) => Messanger(),
        },
        initialRoute: LoginScreen.id,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
