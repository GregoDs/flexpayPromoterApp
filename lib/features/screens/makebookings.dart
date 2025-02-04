import 'dart:math';
import 'package:flexpromoter/features/controllers/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MakeBookings extends StatefulWidget {
  const MakeBookings({super.key});

  @override
  _MakeBookingsState createState() => _MakeBookingsState();
}

class _MakeBookingsState extends State<MakeBookings> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _productNameController = TextEditingController();
  final _paymentDurationController = TextEditingController();
  final _priceController = TextEditingController();
  final _initialDepositController = TextEditingController();

  final UserController userController = Get.find();
  late final String userId;

  bool isLoading = false; //booking is not yet being processed
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    userId = userController.getUserId();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _productNameController.dispose();
    _paymentDurationController.dispose();
    _priceController.dispose();
    _initialDepositController.dispose();
    super.dispose();
  }

  Future<void> _createBooking() async {
    setState(() {
      isLoading = true;
      isButtonDisabled = true;
    });

    final url =
        Uri.parse('https://bookings.flexpay.co.ke/api/booking/promoter-create');

    final Map<String, dynamic> body = {
      'user_id': userId,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'phone_number': _phoneController.text,
      'product_name': _productNameController.text,
      'booking_days': int.tryParse(_paymentDurationController.text) ?? 0,
      'booking_price': double.tryParse(_priceController.text) ?? 0.0,
      'initial_deposit': double.tryParse(_initialDepositController.text) ?? 0.0,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        String bookingReference =
            responseData['data']['product_booking']['booking_reference'] ?? '';
        String bookingPrice = responseData['data']['product_booking']
                    ['booking_price']
                ?.toString() ??
            '';

        userController.setBookingReference(bookingReference);
        userController.setBookingPrice(bookingPrice);

        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
        _productNameController.clear();
        _paymentDurationController.clear();
        _priceController.clear();
        _initialDepositController.clear();

        Get.snackbar("Success", "Your booking has been created successfully.");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Booking Created Successfully!',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Your booking reference is $bookingReference, and the booking price is $bookingPrice.',
                style: GoogleFonts.montserrat(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showExitDialog();
                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.montserrat(),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        String errorMessage = "Booking failed: ";
        if (responseData['errors'] != null) {
          responseData['errors'].forEach((key, value) {
            errorMessage += '$key: ${value.join(', ')}; ';
          });
        }
        Get.snackbar("Error", errorMessage);
      }
    } catch (error) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
        isButtonDisabled = false;
      });
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Go Back to Homepage?",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Do you want to go back to the homepage now?",
            style: GoogleFonts.montserrat(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAllNamed('/home');
              },
              child: Text('Yes', style: GoogleFonts.montserrat()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                   
              },
              child: Text('No', style: GoogleFonts.montserrat()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF337687),
        elevation: 0,
        toolbarHeight: 100.0,
        title: Text(
          "FlexPay",
          style: GoogleFonts.montserrat(
            fontSize: 33.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _paymentDurationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Payment Duration (in days)',
                  labelStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _initialDepositController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Initial Deposit',
                  labelStyle: GoogleFonts.montserrat(),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
             SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: isButtonDisabled ? null : () => _createBooking(),
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E) // Dark mode button color
          : const Color(0xFF337687), // Light mode button color
      foregroundColor: Colors.white, // Text color
      padding: const EdgeInsets.symmetric(vertical: 16), // Button padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded edges
      ),
    ),
    child: isLoading
        ? const CircularProgressIndicator(color: Colors.white)
        : Text(
            'Create Booking',
            style: GoogleFonts.montserrat(fontSize: 16),
          ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
