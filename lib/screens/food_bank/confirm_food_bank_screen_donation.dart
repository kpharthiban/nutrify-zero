import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Adjust path if needed
import 'food_banks_list_screen.dart'; // Import FoodBank model (or from model file)
// Import the success screen - decide if using the same one or a new one
import 'food_bank_donation_success_screen.dart';

class ConfirmFoodBankDonationScreen extends StatefulWidget {
  final FoodBank foodBank; // Receive the FoodBank data

  const ConfirmFoodBankDonationScreen({required this.foodBank, super.key});

  @override
  State<ConfirmFoodBankDonationScreen> createState() => _ConfirmFoodBankDonationScreenState();
}

class _ConfirmFoodBankDonationScreenState extends State<ConfirmFoodBankDonationScreen> {
  final _verificationCodeController = TextEditingController();

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  // Helper to display read-only details (same as HungerSpot version)
  Widget _buildReadOnlyDetailItem(String label, String value, {int minLines = 1}) {
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
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            //  minLines: minLines, // Use for multi-line text
             maxLines: null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define colors (mostly green theme)
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color primaryRed = Color(0xFFE53935);
    const Color lightGreyBackground = Color(0xFFF0F0F0);

    // Combine name and address for location display
    String locationDisplay = '${widget.foodBank.name}, ${widget.foodBank.address}';

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
            const Divider(height: 20, thickness: 1),

            // --- Read-only Food Bank Details ---
            _buildReadOnlyDetailItem('Location', locationDisplay),
            _buildReadOnlyDetailItem('Contact Number', widget.foodBank.phone),
            _buildReadOnlyDetailItem('Description / More Details', widget.foodBank.description, minLines: 3), // Allow more lines

            const SizedBox(height: 24.0),

            // --- Verification Code Input ---
             const Text(
              // Label text updated slightly as per cd fb.png
              'Verification Code (Receive from Food Bank):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _verificationCodeController,
              decoration: InputDecoration(
                hintText: 'XXX-XXX-XXX (9 digits) - Gain points!',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                filled: true,
                fillColor: lightGreyBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              ),
            ),

            const SizedBox(height: 30.0),

            // --- Action Buttons ---
            Column(
              children: [
                // --- Confirm Button ---
                ElevatedButton.icon(
                  onPressed: () async { // Make async if needed
                    // TODO: Implement food bank donation confirmation logic
                    // 1. Validate code: _verificationCodeController.text
                    bool isValid = true; // Placeholder
                    int pointsAwarded = 500; // Placeholder

                    if (isValid) {
                      // Simulate backend/processing
                      // await Future.delayed(Duration(seconds: 1));

                      // Navigate to Success Screen (using the existing one for now)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodBankDonationSuccessScreen(
                            pointsEarned: pointsAwarded,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid verification code.')),
                      );
                    }
                    // print('Confirm Donation pressed. Code: ${_verificationCodeController.text}');
                  },
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text('Confirm Donation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),

                const SizedBox(height: 12.0),

                // --- Close Button ---
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Go back
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}