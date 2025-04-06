import 'package:flutter/material.dart';

// Import the shared custom widgets
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart'; // Import the updated shared bottom nav bar

// Import the target screens for navigation
import '../screens/donate/donate_screen.dart';      // Adjust path if needed
import '../screens/hunger_map/hunger_map_screen.dart';// Adjust path if needed
import '../screens/food_bank/food_bank_screen.dart'; // Adjust path if needed
import '../screens/discover/discover_screen.dart';  // Adjust path if needed (Create if doesn't exist)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Use const constructor

  // Helper for the Home Screen Navigation Cards
  // (Similar to DonateScreen's _buildColorNavigationCard but uses description)
  Widget _buildHomeNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description, // Changed from subtitle to description
    required Color backgroundColor,
    required Widget targetScreen, // Pass the screen widget directly
  }) {
    return GestureDetector(
      onTap: () => Navigator.push( // Use push, not pushReplacementNamed from home
        context,
        MaterialPageRoute(builder: (_) => targetScreen),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0), // Add space below card
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.white), // Icon on the left
            const SizedBox(width: 16),
            Expanded( // Text content takes remaining space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description, // Use the longer description text
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13, // Slightly smaller font for description
                      height: 1.3 // Adjust line spacing if needed
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8), // Space before arrow
            const Icon(Icons.arrow_forward, color: Colors.white), // Arrow on the right
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
     // Define colors (ensure consistency)
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color primaryRed = Color(0xFFE53935);
    const Color textColor = Colors.black87;
    const Color subtitleColor = Colors.black54;


    return Scaffold(
      // Use the updated CustomAppBar, hide back button on home
      appBar: const CustomAppBar(
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        // Use symmetric padding for consistency
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Text ---
            const Text(
              'You are in the right place for',
              style: TextStyle(fontSize: 16, color: subtitleColor),
            ),
            const SizedBox(height: 4),
            const Text(
              'Building a Hunger-Free\nCommunity.',
              style: TextStyle(
                  fontSize: 28, // Adjust size
                  fontWeight: FontWeight.bold,
                  color: primaryGreen, // Green color
                  height: 1.2 // Adjust line height
               ),
            ),
            const SizedBox(height: 24), // Space before cards

            // --- Feature Cards Column ---
            // Replace GridView with Column and custom cards
            _buildHomeNavigationCard(
               context: context,
               // Use placeholder icons matching bottom nav
               icon: Icons.volunteer_activism_outlined,
               title: 'Donate',
               description: 'Share surplus food and contribute directly to those in need. Easily connect with local food banks and individuals.',
               backgroundColor: primaryGreen,
               targetScreen: const DonateScreen(), // Navigate to DonateScreen
            ),
             _buildHomeNavigationCard(
               context: context,
               icon: Icons.explore_outlined,
               title: 'HungerMap',
               description: 'Visualize food insecurity, find location of those needing help, and request assistance if needed.',
               backgroundColor: primaryRed, // Red color for HungerMap card
               targetScreen: const HungerMapScreen(), // Navigate to HungerMapScreen
            ),
             _buildHomeNavigationCard(
               context: context,
               icon: Icons.inventory_2_outlined, // Placeholder icon
               title: 'Food Bank',
               description: 'Connect with local food banks. Find locations, operating hours, and learn how to access or contribute to their services.',
               backgroundColor: primaryGreen,
               targetScreen: FoodBankScreen(), // Navigate to FoodBankScreen
            ),
             _buildHomeNavigationCard(
               context: context,
               icon: Icons.search, // Placeholder icon
               title: 'Discover',
               description: 'Explore educational resources, nutrition tips, and about malnutritions. Learn more about food security and how you can make a difference.',
               backgroundColor: primaryGreen,
               targetScreen: DiscoverScreen(), // Navigate to DiscoverScreen (ensure this exists)
            ),
             const SizedBox(height: 20), // Padding at the bottom
          ],
        ),
      ),
      // Use the shared CustomBottomNavBar. Assuming home corresponds to index 0 (Donate).
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}