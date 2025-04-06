import 'package:flutter/material.dart';

// Import shared widgets (Adjust paths if necessary)
import '../../widgets/custom_app_bar.dart';
// Removed BottomNavBar import as it's usually not shown on profile screen itself
// import '../../widgets/bottom_nav_bar.dart';

// Import target screens for navigation (Adjust paths if necessary)
import 'exchange_points_screen.dart';
import 'points_transaction_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key}); // Use const constructor

  // --- Helper for Action Boxes (Points Transaction, Exchange) ---
  Widget _buildProfileActionBox({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Widget targetScreen,
  }) {
    return Expanded( // Use Expanded to make boxes share width
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        ),
        child: Container(
          // height: 120, // Optional: Set a fixed height or let content decide
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0), // Adjust padding
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.0),
             boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.1),
                 blurRadius: 4,
                 offset: const Offset(0, 2),
               )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Logout Dialog Logic --- (Keep as is)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
            onPressed: () {
              print("Logout Action Triggered"); // Placeholder
              // TODO: Implement actual logout logic (clear auth state, etc.)

              // Navigate back to initial route (e.g., login or home) and remove history
              Navigator.of(context).pushNamedAndRemoveUntil(
                 '/', // Or your initial route like '/home' or '/'
                 (Route<dynamic> route) => false, // Remove all routes
               );
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
     // --- Define Colors ---
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color primaryRed = Color(0xFFE53935);
    // Example BlueGrey - Adjust shade as needed (Colors.blueGrey[300]?)
    final Color blueGrey = Colors.blueGrey.shade300;
    const Color subtitleColor = Colors.black54;

    // --- Placeholder User Data --- (Replace with actual data)
    const String userName = 'Alice Smith';
    const String userEmail = 'alice.smith456@example.email.com';
    const String userImageUrl = 'https://placekitten.com/g/200/200'; // Placeholder
    const int userPoints = 1000;

    return Scaffold(
      // Show back button? Depends if user navigates TO profile or if it's a root tab
      // Let's assume it's navigated TO, so back button is okay.
      appBar: const CustomAppBar(showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // --- Header ---
            const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryGreen, // Red title
              ),
            ),
             const Divider(height: 25, thickness: 1),

             // --- User Info Card ---
             Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                   color: primaryGreen, // Green background
                   borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                   children: [
                      CircleAvatar(
                         radius: 28, // Adjust size
                         backgroundColor: Colors.white.withOpacity(0.5),
                         backgroundImage: NetworkImage(userImageUrl),
                         onBackgroundImageError: (e, s) => print("Error loading image: $e"), // Handle error
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                         child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                  userName,
                                  style: const TextStyle(
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                  ),
                               ),
                               const SizedBox(height: 4),
                               Text(
                                  userEmail,
                                  style: TextStyle(
                                     color: Colors.white.withOpacity(0.9),
                                     fontSize: 13,
                                  ),
                               ),
                            ],
                         ),
                      ),
                   ],
                ),
             ),
             const SizedBox(height: 16),

             // --- Logout Button ---
             Center(
                child: ElevatedButton.icon(
                   onPressed: () => _showLogoutDialog(context),
                   icon: const Icon(Icons.logout, size: 18),
                   label: const Text('Logout'),
                   style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20.0), // Pill shape
                      ),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                   ),
                ),
             ),
             const SizedBox(height: 24),

             // --- Points Display Card ---
             Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(12.0),
                   border: Border.all(color: primaryGreen, width: 1.5),
                ),
                child: Row(
                   children: [
                      const Text(
                         'My Points',
                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
                      const Spacer(), // Pushes points to the right
                      Text(
                         '$userPoints pts', // Display points
                         style: const TextStyle(
                            fontSize: 26, // Large points text
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                         ),
                      ),
                   ],
                ),
             ),
             const SizedBox(height: 16),

             // --- Action Buttons Grid/Row ---
             Row(
                children: [
                   _buildProfileActionBox(
                      context: context,
                      icon: Icons.show_chart, // Chart icon
                      text: 'View My\nPoints Transaction',
                      backgroundColor: Color(0xFF227B94), // Blue-grey color
                      targetScreen: PointsTransactionScreen(),
                   ),
                   const SizedBox(width: 16), // Space between boxes
                   _buildProfileActionBox(
                      context: context,
                      icon: Icons.park_outlined, // Plant/Park icon
                      text: 'Exchange Points\nto Plant a Tree!', // Multi-line text
                      backgroundColor: primaryGreen, // Green color
                      targetScreen: ExchangePointsScreen(),
                   ),
                ],
             ),
             const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
      // Removed BottomNavBar from Profile screen
      // bottomNavigationBar: CustomBottomNavBar(currentIndex: ???), // Decide index if needed
    );
  }
}