import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailScreen extends StatelessWidget {
  final List<dynamic> bookings;
  final String title;

  const BookingDetailScreen({
    super.key,
    required this.bookings,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black :  const Color(0xFF337687),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black :  const Color(0xFF337687),
        centerTitle: true,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        itemBuilder: (context, index) {
          final item = bookings[index];
          final bool isRedeemed = item['redeemed_amount'] != null;
          final bool isActiveOrCompleted = item['progress'] != null;

          final bookingDetails = isRedeemed
              ? {
                  'Booking Reference': item['booking_reference'] ?? '',
                  'Product Name': item['product_name'] ?? 'Redeemed Voucher',
                  'Booking Price': item['booking_price'] ?? '',
                  'Redeemed Amount': item['redeemed_amount'] ?? '',
                  'Redeemed Date': item['redeemed_date'] ?? '',
                  'Customer Phone': item['phone_number'] ?? '',
                  'Branch': item['outlet_name'] ?? '',
                }
              : isActiveOrCompleted
                  ? {
                      'Booking Reference': item['booking_reference'] ?? '',
                      'Product Name': item['product']?['product_name'] ?? '',
                      'Booking Price': item['booking_price'] ?? '',
                      'Progress': item['progress'] ?? '0',
                      'Interest Paid': (item['payment'] != null &&
                              item['payment'].isNotEmpty)
                          ? item['payment'].first['payment_amount']
                          : '0',
                      'Customer Phone':
                          item['customer']?['phone_number_1'] ?? '',
                      'Booking Date': item['created_at'] ?? '',
                      'Branch': item['outlet']?['outlet_name'] ?? '',
                    }
                  : null;

          return Card(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 12.0),
              title: Text(
                bookingDetails?['Product Name'] ?? 'Booking Item',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                'Reference: ${bookingDetails?['Booking Reference']}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              trailing: Icon(Icons.chevron_right,
                  color: isDarkMode ? Colors.white70 : Colors.black54),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(
                        'Booking Details',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: bookingDetails!.entries.map((entry) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                '${entry.key}: ${entry.value}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blueAccent,
                          ),
                          child: Text(
                            'Close',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: isDarkMode ? Colors.blueAccent : Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}