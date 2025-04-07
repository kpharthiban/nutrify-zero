import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

// Import your profile screen if using MaterialPageRoute instead of named routes
// import '../profile/profile_screen.dart'; // Adjust path if necessary
// Import your home screen if using MaterialPageRoute instead of named routes
// import '../screens/home_screen.dart'; // Adjust path if necessary


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onProfilePressed; // Optional custom action for profile tap

  // Define colors (ensure consistency)
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color iconColor = primaryGreen;

  const CustomAppBar({
    super.key,
    this.showBackButton = true, // Default to show, set false on home page
    this.onProfilePressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height

  @override
  Widget build(BuildContext context) {
    // Decide if the back button should be potentially visible
    final bool canGoBack = Navigator.canPop(context);
    final bool displayBackButton = showBackButton && canGoBack;

    // --- Get User Image URL from Firebase Auth ---
    // This gets the currently logged-in user's data synchronously.
    // For more complex state management (like showing loading spinners
    // while auth state resolves), you might use a StreamBuilder or Provider higher up.
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? userImageUrl = currentUser?.photoURL;

    // Determine if the URL is valid
    final bool hasValidImageUrl = userImageUrl != null && userImageUrl.isNotEmpty;
    // --- End Get User Image URL ---

    return AppBar(
      backgroundColor: Colors.transparent, // Match scaffold background
      elevation: 0, // No shadow
      foregroundColor: iconColor, // Default color for icons
      automaticallyImplyLeading: false, // Manual control
      leading: displayBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: iconColor),
              onPressed: () => Navigator.pop(context),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null, // No back button if not needed

      // --- Title Widget (Logo + Text, Tappable) ---
      title: GestureDetector(
        onTap: () {
          // Navigate home when title is tapped
          print('NutrifyZero title tapped - Navigating home');
          // Ensure '/home' route exists or use MaterialPageRoute
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Your App Logo ---
            Image.asset(
              'assets/images/nutrify_zero_app_bar.png', // <<< Use your logo path
              height: 28,
              width: 28,
              errorBuilder:(context, error, stackTrace) => const Icon(Icons.eco_outlined, color: primaryGreen, size: 28), // Fallback Icon
            ),
            const SizedBox(width: 8),
            const Text(
              'NutrifyZero',
              style: TextStyle(
                color: primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      centerTitle: !displayBackButton, // Center title if no back button

      // --- Actions (Profile Icon) ---
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            tooltip: 'Profile',

            // --- CircleAvatar with Profile Pic & Placeholder ---
            icon: CircleAvatar(
              radius: 18, // Adjust size as needed
              backgroundColor: Colors.grey[300], // Background if child/image not visible

              // Conditionally set backgroundImage using the fetched URL
              backgroundImage: hasValidImageUrl ? NetworkImage(userImageUrl!) : null,

              // Provide the child placeholder icon.
              // It's shown if backgroundImage is null OR fails to load.
              child: !hasValidImageUrl
                  ? Icon(
                      Icons.person_outline, // Default person icon
                      size: 20,             // Adjust size
                      color: Colors.grey[600], // Adjust color
                    )
                  : null, // Don't show icon initially if trying to load image

              // Log errors if image loading fails
              onBackgroundImageError: hasValidImageUrl ? (exception, stackTrace) {
                 print("Error loading profile image in AppBar: $exception");
              } : null,
            ),
             // --- End CircleAvatar ---

            onPressed: onProfilePressed ?? () {
              // Default action: Navigate to profile screen
              print('Profile icon tapped - Navigating to profile');
              // Ensure '/profile' route exists or use MaterialPageRoute
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
      ],
    );
  }
}