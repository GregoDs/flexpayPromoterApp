
import 'package:flexpromoter/features/controllers/usercontroller.dart';
import 'package:flexpromoter/features/screens/bookingspage.dart';
import 'package:flexpromoter/features/screens/commissionspage.dart';
import 'package:flexpromoter/features/screens/homescreen.dart';
import 'package:flexpromoter/features/screens/leaderboard.dart';
import 'package:flexpromoter/features/screens/loginscreen.dart';
import 'package:flexpromoter/features/screens/makebookings.dart';
import 'package:flexpromoter/features/screens/onboardingscreen.dart';
import 'package:flexpromoter/features/screens/splashscreen.dart';
import 'package:flexpromoter/features/screens/validatedreceipts.dart';
import 'package:flexpromoter/util/device/device_utility.dart';
import 'package:flexpromoter/util/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(UserController()); // Initialize the UserController 
  runApp(const FlexMerchandiserApp());
}

class FlexMerchandiserApp extends StatelessWidget {
  const FlexMerchandiserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            DeviceUtil.init(context); // Initialize DeviceUtil for screen utilities

            // Determine the screen width and height
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            // Log screen dimensions for debugging
            debugPrint("Screen Width: $screenWidth, Screen Height: $screenHeight");

            return GetMaterialApp(
              debugShowCheckedModeBanner: false, // Remove debug banner
              themeMode: ThemeMode.system,
              theme: TAppTheme.lightTheme,
              darkTheme: TAppTheme.darkTheme,
              initialRoute: '/',
              getPages: [
                GetPage(name: '/', page: () => const SplashScreen()),
                GetPage(name: '/onboarding', page: () => OnboardingScreen()),
                GetPage(name: '/login', page: () => LoginScreen()),
                GetPage(name: '/home', page: () => HomeScreen()),
                GetPage(name: '/bookings', page: () => Bookings()),
                GetPage(name: '/commissions', page: () => Commissions()),
                GetPage(name: '/leaderboard', page: () => Leaderboard()),
                GetPage(name: '/validatedReceipts', page: () => ValidatedReceiptsPage(validatedReceipts: [],)),
                GetPage(name: '/makeBookings', page: () => MakeBookings()),
              ],
            );
          }
        );
      },
    );
  }
}