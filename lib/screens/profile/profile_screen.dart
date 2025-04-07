import 'package:flutter/material.dart';

// Import shared widgets (Adjust paths if necessary)
import '../../widgets/custom_app_bar.dart';
// Removed BottomNavBar import
// import '../../widgets/bottom_nav_bar.dart';

// Import target screens for navigation (Adjust paths if necessary)
import 'exchange_points_screen.dart';
import 'points_transaction_screen.dart';
import '../auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- Helper for Action Boxes (Points Transaction, Exchange) ---
  Widget _buildProfileActionBox({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Widget targetScreen,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
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
            mainAxisAlignment: MainAxisAlignment.center,
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

  // --- Updated Logout Dialog Logic ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      // barrierDismissible: false, // Optional: prevent dismissing by tapping outside
      builder: (dialogContext) => AlertDialog( // Use dialogContext for clarity
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            // Use dialogContext to pop only the dialog
            onPressed: () => Navigator.pop(dialogContext),
          ),
          TextButton(
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
            // --- Make onPressed async ---
            onPressed: () async {
              print("Logout Action Triggered");
              Navigator.pop(dialogContext); // Close dialog first

              try {
                 // Sign out from Google
                 await GoogleSignIn().signOut();
                 print("Signed out from Google");

                 // Sign out from Firebase
                 await FirebaseAuth.instance.signOut();
                 print("Signed out from Firebase");

                 // *** RESTORE NAVIGATION TO LOGIN SCREEN ***
                 if (context.mounted) {
                     Navigator.of(context).pushAndRemoveUntil(
                         MaterialPageRoute(builder: (context) => const LoginScreen()), // Go back to LoginScreen
                         (Route<dynamic> route) => false, // Remove all routes
                     );
                     // Optional: If using named routes and '/login' is defined
                     // Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                 }
                 // *** END RESTORED NAVIGATION ***

              } catch (e) {
                 print("Error during logout: $e");
                 if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                          content: Text('Logout failed: $e'),
                          backgroundColor: Colors.red,
                       ),
                    );
                 }
              }
            },
          ),
        ],
      ),
    );
  } // --- End of _showLogoutDialog ---


  @override
  Widget build(BuildContext context) {
     // --- Define Colors ---
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color primaryRed = Color(0xFFE53935);
    final Color blueGrey = Colors.blueGrey.shade300;
    const Color subtitleColor = Colors.black54;

    // Get current user from Firebase Auth
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // --- Use user data (provide defaults if null) ---
    final String userName = currentUser?.displayName ?? 'User Name';
    final String userEmail = currentUser?.email ?? 'user@example.com';
    final String? userImageUrl = currentUser?.photoURL; // Already nullable
    // Fetch points separately if needed
    const int userPoints = 1000; // Keep placeholder or fetch actual points

    // Check validity for image
    final bool hasValidImageUrl = userImageUrl != null && userImageUrl.isNotEmpty;


    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true), // Show back button here
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
                color: primaryGreen, // Use primaryRed for Profile Title
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
                      // --- MODIFIED CircleAvatar ---
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green.shade700, // Fallback color

                        // Conditionally set backgroundImage based on the check
                        backgroundImage: hasValidImageUrl ? NetworkImage(userImageUrl!) : null,

                        

                        onBackgroundImageError: hasValidImageUrl ? (exception, stackTrace) {
                          print("Error loading profile image: $exception");
                        } : null,

                        // Provide the child placeholder - shows if backgroundImage is null/fails
                        child: !hasValidImageUrl
                            ? Icon( // Show icon if NO valid URL initially
                                Icons.person_outline,
                                size: 32,
                                color: Colors.white.withOpacity(0.8),
                              )
                            : null, // Rely on backgroundImage otherwise
                      ),
                      // --- End MODIFIED CircleAvatar ---

                      const SizedBox(width: 16),
                      Expanded(
                         child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                  userName, // Use placeholder data
                                  style: const TextStyle(
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                  ),
                               ),
                               const SizedBox(height: 4),
                               Text(
                                  userEmail, // Use placeholder data
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
    );
  }
}

// Make sure ExchangePointsScreen and PointsTransactionScreen are imported correctly
// class ExchangePointsScreen extends StatelessWidget { ... } // Placeholder
// class PointsTransactionScreen extends StatelessWidget { ... } // Placeholder