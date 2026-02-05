import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'pages/welcome_page.dart';
import 'pages/signin_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/signup_page.dart';
import 'pages/otp_verification_page.dart';
import 'pages/user_details_setup_page.dart';
import 'pages/home_screen_page.dart';

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
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/signup': (context) => const SignUpPage(),
        '/otp-verification': (context) => const OtpVerificationPage(),
        '/user-details-setup': (context) => const UserDetailsSetupPage(),
        '/home': (context) => const HomeScreenPage(),
      },
    );
  }
}
