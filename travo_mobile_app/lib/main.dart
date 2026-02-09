import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'core/utils/page_transitions.dart';
import 'pages/welcome_page.dart';
import 'pages/signin_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/signup_page.dart';
import 'pages/otp_verification_page.dart';
import 'pages/user_details_setup_page.dart';
import 'pages/home_screen_page.dart';
import 'pages/ai_chat_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_profile_page.dart';
import 'pages/my_stories_page.dart';
import 'pages/story_details_page.dart';
import 'pages/add_story_details_page.dart';
import 'pages/recommendations_overlay_page.dart';
import 'pages/place_details_page.dart';
import 'pages/transportation_page.dart';
import 'pages/adventure_page.dart';
import 'pages/map_page.dart';

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
      onGenerateRoute: (settings) {
        Widget page;
        
        switch (settings.name) {
          case '/':
            page = const WelcomePage();
            break;
          case '/signin':
            page = const SignInPage();
            break;
          case '/forgot-password':
            page = const ForgotPasswordPage();
            break;
          case '/signup':
            page = const SignUpPage();
            break;
          case '/otp-verification':
            page = const OtpVerificationPage();
            break;
          case '/user-details-setup':
            page = const UserDetailsSetupPage();
            break;
          case '/home':
            page = const HomeScreenPage();
            break;
          case '/ai-chat':
            page = const AiChatPage();
            break;
          case '/profile':
            page = const ProfilePage();
            break;
          case '/edit-profile':
            page = const EditProfilePage();
            break;
          case '/story':
            page = const MyStoriesPage();
            break;
          case '/story-details':
            final tripTitle = settings.arguments as String?;
            page = StoryDetailsPage(tripTitle: tripTitle ?? 'Trip');
            break;
          case '/add-story-details':
            final destinationName = settings.arguments as String?;
            page = AddStoryDetailsPage(destinationName: destinationName ?? 'Destination');
            break;
          case '/recommendations':
            page = const TravoRecommendationsPage();
            break;
          case '/place-details':
            page = const TravoPlaceDetailsPage();
            break;
          case '/transportation':
            page = const TransportationPage();
            break;
          case '/adventure':
            page = const TravoAdventurePage();
            break;
          case '/map':
            page = const MapPage();
            break;
          default:
            page = const WelcomePage();
        }
        
        return SlideRightRoute(page: page);
      },
    );
  }
}
