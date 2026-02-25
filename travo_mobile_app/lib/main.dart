import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'core/utils/page_transitions.dart';
import 'data/adventure_data.dart';
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
        bool isMainPage = false; // Track if it's a main navbar page

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
            isMainPage = true;
            break;
          case '/ai-chat':
            page = const AiChatPage();
            isMainPage = true;
            break;
          case '/profile':
            page = const ProfilePage();
            break;
          case '/edit-profile':
            page = const EditProfilePage();
            break;
          case '/story':
            page = const MyStoriesPage();
            isMainPage = true;
            break;
          case '/story-details':
            final trip = settings.arguments as SavedTrip?;
            if (trip == null) {
              page = const MyStoriesPage();
            } else {
              page = StoryDetailsPage(trip: trip);
            }
            break;
          case '/add-story-details':
            final destinationName = settings.arguments as String?;
            page = AddStoryDetailsPage(
              destinationName: destinationName ?? 'Destination',
            );
            break;
          case '/recommendations':
            page = const TravoRecommendationsPage();
            break;
          case '/adventure':
            page = const TravoAdventurePage();
            isMainPage = true;
            break;
          case '/map':
            page = const MapPage();
            isMainPage = true;
            break;
          default:
            page = const WelcomePage();
        }

        // Use NoTransitionRoute for main navbar pages, SlideRightRoute for others
        if (isMainPage) {
          return NoTransitionRoute(page: page, settings: settings);
        } else {
          return SlideRightRoute(page: page, settings: settings);
        }
      },
    );
  }
}
