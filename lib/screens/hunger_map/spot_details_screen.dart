// In spot_details_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import 'spots_list_screen.dart'; // Or your model file
import 'confirm_donation_screen.dart';

class SpotDetailsScreen extends StatelessWidget {
  final HungerSpot spot;

  const SpotDetailsScreen({required this.spot, super.key});

  // --- _buildDetailItem helper remains the same ---
  Widget _buildDetailItem(BuildContext context, String label, String value, {int minLines = 1}) {
     // ... (no changes needed here) ...
     const Color primaryRed = Color(0xFFE53935); // Use consistent color

     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             label + ':',
             style: const TextStyle(
               fontSize: 14,
               fontWeight: FontWeight.w600, // Semi-bold label
               color: Colors.black87,
             ),
           ),
           const SizedBox(height: 6.0),
           Container(
             width: double.infinity, // Take full width
             padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(8.0),
               border: Border.all(color: primaryRed, width: 1.0),
             ),
             child: Text(
               value,
               style: const TextStyle(fontSize: 15, color: Colors.black87),
              //  minLines: minLines, // For description
               maxLines: null, // Allow multiple lines
             ),
           ),
         ],
       ),
     );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935);
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color darkGreyText = Color(0xFF616161); // For '*Added by me' text

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Screen Title ---
            Text(
              'HungerSpot Details',
              style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: primaryRed,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'ID: ${spot.id}',
              style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: primaryRed,
              ),
            ),

            // --- *Added by me Indicator (Conditional) ---
            if (spot.addedByUser) // Show only if added by user
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '*Added by me',
                  style: TextStyle(
                    fontSize: 14,
                    color: darkGreyText, // Use a less prominent color
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 20.0), // Space before details

            // --- Detail Items ---
            _buildDetailItem(context, 'Location', spot.location, minLines: 2),
            _buildDetailItem(context, 'Contact Number', spot.phone),
            _buildDetailItem(context, 'Number of people', spot.numberOfPeople.toString()),
            _buildDetailItem(context, 'Description / More Details', spot.description, minLines: 3),

            // --- Verification Code Section (Conditional) ---
            if (spot.addedByUser && spot.verificationCode != null && spot.verificationCode!.isNotEmpty) // Show only if added by user and code exists
              Padding(
                padding: const EdgeInsets.only(top: 16.0), // Add space above
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
                        color: primaryRed, // Red background
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        spot.verificationCode!, // Display the code
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
              child: Column( // Use Column to ensure proper spacing if needed later
                children: [
                  // --- Donate Button (Show if NOT added by user) ---
                  if (!spot.addedByUser)
                    ElevatedButton.icon(
                      onPressed: () {
                        // !!! --- UPDATE THIS --- !!!
                        // Navigate to Confirm Donation Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmDonationScreen(spot: spot), // Pass spot data
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
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
                  if (spot.addedByUser)
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement Delete action
                        // Show confirmation dialog?
                        print('Delete button pressed for spot ${spot.id}');
                        // Maybe Navigator.pop(context); after successful deletion?
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.white), // Trash icon
                      label: const Text('Delete HungerSpot'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed, // Red background
                        foregroundColor: Colors.white, // White text/icon
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Adjusted padding
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