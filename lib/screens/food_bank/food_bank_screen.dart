import 'package:flutter/material.dart';

// Assuming these widgets exist at these paths, adjust if necessary
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_app_bar.dart';
import 'add_food_bank_screen.dart';
import 'food_banks_list_screen.dart';

class FoodBankScreen extends StatelessWidget {
  const FoodBankScreen({super.key}); // Use const constructor

  @override
  Widget build(BuildContext context) {
    // Define colors (ensure consistency)
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color textColor = Colors.black87;
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      appBar: const CustomAppBar(), // Use your custom app bar
      body: Column( // Main column for Header, Map, Buttons
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                 Text(
                  'Food Bank', // Title
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen, // Green title
                  ),
                ),
                 SizedBox(height: 4),
                 Text(
                  'Find your local food bank and support them.', // Subtitle
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ),

          // --- Map Area ---
          Expanded(
            // flex: 3, // Adjust flex factor if needed relative to buttons area
            child: Container(
              // margin: const EdgeInsets.symmetric(horizontal: 8.0), // Optional margin
              child: Stack( // Use Stack to overlay text on the map placeholder
                children: [
                  // --- MAP PLACEHOLDER ---
                  // Replace this Container with your actual map widget (e.g., GoogleMap)
                  Container(
                    decoration: BoxDecoration(
                       color: Colors.grey[300], // Placeholder background
                       // borderRadius: BorderRadius.circular(12.0), // Optional border
                    ),
                    child: const Center(
                        child: Text(
                           'MAP PLACEHOLDER\n(Integrate Google Maps here)',
                           textAlign: TextAlign.center,
                           style: TextStyle(color: Colors.grey),
                         )
                     ),
                  ),
                  // --- END MAP PLACEHOLDER ---

                  // --- Overlay Text ---
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15.0), // Space from bottom
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6), // Semi-transparent black
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Text(
                         // *** Corrected text for Food Banks ***
                        'Tap anywhere to add or view Food Banks',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ), // End of Expanded Map Area

          // --- Action Buttons Row ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Padding around the row
            child: Row(
              children: [
                // Add Food Bank Button (Solid Green)
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.inventory_2_outlined, color: Colors.white), // Placeholder Icon
                    label: const Text('Add Food Bank'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddFoodBankScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen, // Green background
                      foregroundColor: Colors.white, // White text/icon
                      padding: const EdgeInsets.symmetric(vertical: 14), // Button padding
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons

                // List of Food Banks Button (Outlined Green)
                Expanded(
                  child: OutlinedButton.icon(
                     icon: const Icon(Icons.format_list_bulleted, color: primaryGreen), // List Icon
                     label: const Text('List of Food Banks'),
                     onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FoodBanksListScreen()), // Navigate to list screen
                     ),
                     style: OutlinedButton.styleFrom(
                       foregroundColor: primaryGreen, // Green text/icon
                       side: const BorderSide(color: primaryGreen, width: 1.5), // Green border
                       padding: const EdgeInsets.symmetric(vertical: 14), // Button padding
                        shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12.0),
                       ),
                       textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                     ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Use the shared bottom nav bar, set correct index
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2), // Food Bank tab active
    );
  }
}