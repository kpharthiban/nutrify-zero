import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Adjust path if needed
import 'food_banks_list_screen.dart'; // Import the FoodBank model
import 'confirm_food_bank_screen_donation.dart';

class FoodBankDetailsScreen extends StatelessWidget {
  final FoodBank foodBank;

  const FoodBankDetailsScreen({required this.foodBank, super.key});

  // --- _buildDetailItem helper remains the same ---
  Widget _buildDetailItem(BuildContext context, String label, String value, {int minLines = 1}) {
    const Color primaryGreen = Color(0xFF4CAF50); // Use consistent color
     // ... (implementation is the same as before) ...
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             label + ':',
             style: const TextStyle(
               fontSize: 14,
               fontWeight: FontWeight.w600,
               color: Colors.black87,
             ),
           ),
           const SizedBox(height: 6.0),
           Container(
             width: double.infinity,
             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(8.0),
               border: Border.all(color: primaryGreen, width: 1.0), // Green border
             ),
             child: Text(
               value,
               style: const TextStyle(fontSize: 15, color: Colors.black87),
              //  minLines: minLines, // Use for multi-line fields
               maxLines: null,
             ),
           ),
         ],
       ),
     );
  }

  @override
  Widget build(BuildContext context) {
    // Define colors
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color primaryRed = Color(0xFFE53935); // Use the red from previous screens
    const Color darkGreyText = Color(0xFF616161); // For '*Added by me'

    String locationDisplay = '${foodBank.name}, ${foodBank.address}';
    String screenTitle = 'Food Bank #${foodBank.id}';

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Screen Title ---
            Text(
              screenTitle,
              style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen,
              ),
            ),

            // --- *Added by me Indicator (Conditional) ---
            if (foodBank.addedByUser)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '*Added by me',
                  style: TextStyle(
                    fontSize: 14,
                    color: darkGreyText,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 20.0), // Space before details

            // --- Detail Items ---
            _buildDetailItem(context, 'Location', locationDisplay, minLines: 2),
            _buildDetailItem(context, 'Contact Number', foodBank.phone),
            _buildDetailItem(context, 'Description / More Details', foodBank.description, minLines: 4),

            // --- Verification Code Section (Conditional) ---
            if (foodBank.addedByUser && foodBank.verificationCode != null && foodBank.verificationCode!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verification Code (Provide to Donor - if any):',
                      style: TextStyle(
                         fontSize: 14,
                         fontWeight: FontWeight.w600,
                         color: Colors.black87,
                       ),
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: primaryGreen, // Green background for food bank code
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        foodBank.verificationCode!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white, // White text
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30.0), // Space before button area

            // --- Conditional Button Area ---
            Center(
              child: Column(
                children: [
                  // --- Donate Button (Show if NOT added by user) ---
                  if (!foodBank.addedByUser)
                    ElevatedButton.icon(
                      onPressed: () {
                        // !!! --- UPDATE THIS --- !!!
                        // Navigate to Confirm Food Bank Donation Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmFoodBankDonationScreen(foodBank: foodBank), // Pass data
                          ),
                        );
                      },
                      icon: const Icon(Icons.redeem, color: Colors.white),
                      label: const Text('Donate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),

                  // --- Delete Button (Show if ADDED by user) ---
                  if (foodBank.addedByUser)
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement Delete action for Food Bank
                        // Show confirmation dialog?
                        print('Delete button pressed for food bank ${foodBank.id}');
                        // Maybe Navigator.pop(context); after successful deletion?
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.white), // Trash icon
                      // !!! Use correct label !!!
                      label: const Text('Delete Food Bank'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed, // Red background
                        foregroundColor: Colors.white, // White text/icon
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20.0), // Bottom padding
          ],
        ),
      ),
    );
  }
}