
import 'package:flexpromoter/features/screens/homescreen.dart';
import 'package:flexpromoter/features/screens/loginscreen.dart';
import 'package:flexpromoter/features/screens/onboardingscreen.dart';
import 'package:flexpromoter/features/screens/otpverificationscreen.dart';
import 'package:flexpromoter/features/screens/splashscreen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(), // SplashScreen as the initial route
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) => LoginScreen(),
  '/otpverification': (context) => const OTPScreen(
        phoneNumber: '',
      ),
  '/home': (context) =>  HomeScreen(),
};
