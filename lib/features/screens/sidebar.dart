import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Detect current theme mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: screenWidth * 0.6,
      child: Container(
        color: isDarkMode ? const Color(0xFF1E1E1E) :  const Color(0xFF337687), // Background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Sidebar Menu Items
            buildMenuItem(Icons.home, "Home", '/home', isDarkMode),
            buildMenuItem(Icons.book_online, "Bookings", '/bookings', isDarkMode),
            buildMenuItem(Icons.monetization_on, "Commissions", '/commissions', isDarkMode),
            buildMenuItem(Icons.leaderboard, "Leaderboard", '/leaderboard', isDarkMode),
            buildMenuItem(Icons.receipt_long, "Validated Receipts", '/validatedReceipts', isDarkMode),
            buildMenuItem(Icons.book, "Make Bookings", '/makeBookings', isDarkMode),

            const Spacer(),

            // Logout
            buildMenuItem(Icons.logout, "Logout", '/logout', isDarkMode),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Reusable function for sidebar items
  Widget buildMenuItem(IconData icon, String text, String route, bool isDarkMode) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
      title: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          color: isDarkMode ? Colors.white : Colors.white70,
        ),
      ),
      onTap: () => Get.offNamed(route),
    );
  }
}