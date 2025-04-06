import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Adjust path if needed
import '../hunger_map/spots_list_screen.dart'; // Import HungerSpot model (or from model file)
import 'donation_success_screen.dart';

class ConfirmDonationScreen extends StatefulWidget {
  final HungerSpot spot; // Receive the spot data

  const ConfirmDonationScreen({required this.spot, super.key});

  @override
  State<ConfirmDonationScreen> createState() => _ConfirmDonationScreenState();
}

class _ConfirmDonationScreenState extends State<ConfirmDonationScreen> {
  final _verificationCodeController = TextEditingController(); // Controller for the TextField

  @override
  void dispose() {
    _verificationCodeController.dispose(); // Dispose the controller
    super.dispose();
  }

  // Helper to display read-only details
  Widget _buildReadOnlyDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + ':',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black54, // Slightly muted label
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define colors from the design
    const Color primaryGreen = Color(0xFF4CAF50); // Example green color
    const Color primaryRed = Color(0xFFE53935); // Example red color
    const Color lightGreyBackground = Color(0xFFF0F0F0); // For text field

    return Scaffold(
      appBar: CustomAppBar(), // Consistent App Bar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // More padding maybe
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Screen Title ---
            const Text(
              'Confirm Donation',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryGreen, // Green title
              ),
            ),
            const Divider(height: 20, thickness: 1), // Divider below title

            // --- Read-only Spot Details ---
            _buildReadOnlyDetailItem('Location', widget.spot.location),
            _buildReadOnlyDetailItem('Contact Number', widget.spot.phone),
            _buildReadOnlyDetailItem('Number of people', widget.spot.numberOfPeople.toString()),
            _buildReadOnlyDetailItem('Description / More Details', widget.spot.description),

            const SizedBox(height: 24.0), // Space before verification code

            // --- Verification Code Input ---
            const Text(
              'Verification Code (Receive from Recipient):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.text, // Or number if format allows
              // Consider adding input formatters for XXX-XXX-XXX
              decoration: InputDecoration(
                hintText: 'XXX-XXX-XXX (9 digits) - Gain points!',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                filled: true,
                fillColor: lightGreyBackground, // Light grey background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, // No border
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              ),
            ),

            const SizedBox(height: 30.0), // Space before buttons

            // --- Action Buttons ---
            Column(
              children: [
                // --- Confirm Button ---
                ElevatedButton.icon(
                  onPressed: () {
                    // --- UPDATE THIS ---
                    // TODO: Implement actual donation confirmation logic
                    // 1. Validate code: _verificationCodeController.text
                    bool isValid = true; // Placeholder for validation
                    int pointsAwarded = 500; // Placeholder for points from backend/logic

                    if (isValid) {
                      // Simulate backend call/processing delay (optional)
                      // await Future.delayed(Duration(seconds: 1));

                      // Navigate to Success Screen, replacing the current screen
                      Navigator.pushReplacement( // Use pushReplacement
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationSuccessScreen(
                            pointsEarned: pointsAwarded, // Pass the points
                          ),
                        ),
                      );
                    } else {
                      // TODO: Show error message if code is invalid
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid verification code.')),
                      );
                    }
                    // print('Confirm Donation pressed. Code: ${_verificationCodeController.text}'); // Old code
                  },
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text('Confirm Donation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen, // Green background
                    foregroundColor: Colors.white, // White text/icon
                    minimumSize: const Size(double.infinity, 50), // Full width button
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),

                const SizedBox(height: 12.0), // Space between buttons

                // --- Close Button ---
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed, // Red background
                    foregroundColor: Colors.white, // White text/icon
                    minimumSize: const Size(double.infinity, 50), // Full width button
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0), // Bottom padding
          ],
        ),
      ),
       // Assuming BottomNavBar is handled globally
    );
  }
}