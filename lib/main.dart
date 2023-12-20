import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neuro/firebase_options.dart';
import 'package:neuro/userinfo.dart';
import 'login_screen.dart';
import 'signuo_screen.dart';
import 'AdminPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      initialRoute: '/signup', // Specify the initial route
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminPage(),
        '/user': (context) => userinfo(),
      },
    );
  }
}



