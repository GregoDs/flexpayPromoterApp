import 'dart:convert';
import 'package:flexpromoter/features/controllers/usercontroller.dart';
import 'package:flexpromoter/features/screens/bookingdetailsscreen.dart';
import 'package:flexpromoter/features/screens/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  Map<String, dynamic>? bookingsData;
  bool isLoading = true;
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final userId = userController.getUserId();
    debugPrint('Fetching bookings for user ID: $userId');

    try {
      final responses = await Future.wait([
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/open/$userId')),
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/closed/$userId')),
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/redeemed/$userId')),
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/unserviced/$userId')),
      ]);

      final newBookingsData = {
        'Active Bookings': jsonDecode(responses[0].body),
        'Completed Bookings': jsonDecode(responses[1].body),
        'Redeemed Bookings': jsonDecode(responses[2].body),
        'Unserviced Bookings': jsonDecode(responses[3].body),
      };

      setState(() {
        bookingsData = newBookingsData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Get.to(() => SideMenu()),
        ),
        title: Text(
          "FlexPay",
          style: GoogleFonts.montserrat(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        toolbarHeight: screenHeight * 0.12,
      ),
      body: isLoading
          ? _buildLoadingState()
          : bookingsData == null || bookingsData!.isEmpty
              ? _buildNoBookings()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(isDarkMode, screenWidth),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            _buildBookingCards(isDarkMode, screenWidth),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("Fetching Booking Details... Please wait", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildNoBookings() {
    return const Center(
      child: Text("No bookings available.", style: TextStyle(fontSize: 18, color: Colors.grey)),
    );
  }

  Widget _buildHeaderSection(bool isDarkMode, double screenWidth) {
    return Container(
      width: double.infinity,
      color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'View Bookings',
            style: GoogleFonts.montserrat(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Below are your scheduled and past bookings.',
            style: GoogleFonts.montserrat(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w400, color: Colors.white70),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBookingCards(bool isDarkMode, double screenWidth) {
    return Column(
      children: bookingsData!.entries.map((entry) {
        return GestureDetector(
          onTap: () {
            Get.to(() => BookingDetailScreen(bookings: entry.value['data'], title: entry.key));
          },
          child: _buildStyledCard(entry.key, entry.value['data']?.length?.toString() ?? '0', "Tap to view details", isDarkMode, screenWidth),
        );
      }).toList(),
    );
  }

  Widget _buildStyledCard(String title, String value, String message, bool isDarkMode, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.montserrat(fontSize: screenWidth * 0.04, color: isDarkMode ? Colors.white70 : Colors.white),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.montserrat(fontSize: screenWidth * 0.12, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}  

