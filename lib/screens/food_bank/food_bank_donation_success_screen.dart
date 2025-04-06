import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../widgets/custom_app_bar.dart'; // Adjust path if needed
import '../profile/points_transaction_screen.dart'; // Import the target screen for the button

class FoodBankDonationSuccessScreen extends StatelessWidget {
  final int pointsEarned; // Points earned from the donation

  const FoodBankDonationSuccessScreen({
    required this.pointsEarned,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Define colors from the design
    const Color primaryGreen = Color(0xFF4CAF50); // Example green color
    const Color buttonBlue = Color(0xFF26A69A); // Teal/Blue for the button
    const Color lightGreyText = Color(0xFF616161);

    // Get current date for display
    final String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: CustomAppBar(), // Consistent App Bar
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          // Center the main content vertically, but allow app bar and bottom nav
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
          children: [
            // --- Title ---
            const Text(
              'Points Credited!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30, // Larger title
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 30.0),

            // --- Points Display Box ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
              decoration: BoxDecoration(
                border: Border.all(color: primaryGreen, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                '$pointsEarned pts',
                style: const TextStyle(
                  fontSize: 36, // Large points text
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 40.0),

            // --- Transaction Summary ---
            // Using a ListTile for structure and alignment
            ListTile(
               // leading: Icon(Icons.chevron_right, color: lightGreyText), // Icon like in screenshot
               contentPadding: EdgeInsets.zero, // Remove default padding if needed
               title: Text(
                  currentDate, // Display current date
                  style: TextStyle(fontSize: 14, color: lightGreyText),
               ),
               subtitle: const Text(
                  'Donation to Food Bank', // Description
                  style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: Colors.black87),
               ),
               trailing: Text(
                  '+$pointsEarned', // Points earned value
                  style: const TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                     color: primaryGreen,
                  ),
              ),
               // onTap: () { /* Maybe navigate somewhere if this row is tappable? */ },
            ),


            const SizedBox(height: 30.0), // Space before button

            // --- View Transactions Button ---
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Points Transaction Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Ensure this path matches your structure
                    builder: (context) => PointsTransactionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.visibility, color: Colors.white), // Eye icon
              label: const Text('View My Points Transactions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBlue, // Blue/Teal background
                foregroundColor: Colors.white, // White text/icon
                minimumSize: const Size(double.infinity, 50), // Full width button
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),

            const Spacer(), // Pushes content towards center if not enough content
          ],
        ),
      ),
       // Assuming BottomNavBar is handled globally
    );
  }
}