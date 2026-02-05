import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'pages/signin_page.dart';

void main() {
  runApp(const TravoApp());
}

class TravoApp extends StatelessWidget {
  const TravoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
      },
    );
  }
}
