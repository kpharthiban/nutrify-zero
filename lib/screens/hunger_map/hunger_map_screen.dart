import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart'; // Assuming exists
import '../../widgets/custom_app_bar.dart'; // Assuming exists

// Import target screens for navigation
import 'add_spot_screen.dart';
import 'spots_list_screen.dart';
import 'ask_for_help_screen.dart';
import 'my_request_screen.dart';

class HungerMapScreen extends StatelessWidget {
  const HungerMapScreen({super.key}); // Use const constructor

  // Helper for the bottom Red Action Buttons
  Widget _buildRedActionBox({
    required BuildContext context, // Pass context for navigation
    required IconData icon,
    required String label,
    required Widget targetScreen, // Pass the screen widget for navigation
  }) {
    const Color primaryRed = Color(0xFFE53935); // Consistent red

    return Expanded( // Use Expanded to make buttons fill the row width evenly
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0), // Small gap between buttons
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: primaryRed,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: Colors.white), // White icon
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center, // Center text if it wraps
                style: const TextStyle(
                  color: Colors.white, // White text
                  fontSize: 11, // Slightly smaller font size
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935); // Consistent red
    const Color textColor = Colors.black87;
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      appBar: CustomAppBar(), // Your custom app bar
      body: Column( // Main column for Header, Map, Buttons
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0), // Add padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                 Text(
                  'HungerMap',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryRed, // Red title
                  ),
                ),
                 SizedBox(height: 4),
                 Text(
                  'See local needs & request food support.',
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ),

          // --- Map Area ---
          Expanded(
            child: Container(
              // Consider adding margin if needed
              // margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack( // Use Stack to overlay text on the map placeholder
                children: [
                  // --- MAP PLACEHOLDER ---
                  // Replace this Container with your actual map widget (e.g., GoogleMap)
                  Container(
                    decoration: BoxDecoration(
                       color: Colors.grey[300], // Placeholder background
                       // Optional: Add border radius if needed
                       // borderRadius: BorderRadius.circular(12.0),
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
                      margin: const EdgeInsets.only(bottom: 15.0), // Space from bottom edge
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6), // Semi-transparent black
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Text(
                        'Tap anywhere to add or view HungerSpots',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ), // End of Expanded Map Area

          // --- Action Button Bar ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0), // Padding around the row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space
              crossAxisAlignment: CrossAxisAlignment.start, // Align tops if heights differ slightly
              children: [
                _buildRedActionBox(
                  context: context,
                  icon: Icons.add_location_alt_outlined, // Location pin+ icon
                  label: 'Add\nHungerSpots', // Multi-line label
                  targetScreen: AddSpotScreen(), // Navigate to AddSpotScreen
                ),
                _buildRedActionBox(
                  context: context,
                  icon: Icons.auto_awesome, // Sparkle icon (or Icons.volunteer_activism)
                  label: 'Ask for\nHelp', // Multi-line label
                  targetScreen: AskForHelpScreen(), // Navigate to AskForHelpScreen
                ),
                _buildRedActionBox(
                  context: context,
                  icon: Icons.format_list_bulleted, // List icon
                  label: 'List of\nHungerSpots', // Multi-line label
                  targetScreen: SpotsListScreen(), // Navigate to SpotsListScreen
                ),
                _buildRedActionBox(
                  context: context,
                  icon: Icons.receipt_long_outlined, // Request/receipt icon
                  label: 'My\nRequest', // Multi-line label
                  targetScreen: MyRequestScreen(), // Navigate to MyRequestScreen
                ),
              ],
            ),
          ),
        ],
      ),
      // Make sure currentIndex matches the HungerMap tab index in your bottom nav bar
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }
}