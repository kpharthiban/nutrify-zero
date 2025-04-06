import 'package:flutter/material.dart';
// Import your profile screen if using MaterialPageRoute instead of named routes
// import '../profile/profile_screen.dart';
// Import your home screen if using MaterialPageRoute instead of named routes
// import '../screens/home_screen.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Removed title parameter as it's now fixed
  final bool showBackButton;
  final VoidCallback? onProfilePressed; // Optional custom action for profile tap

  // Define colors (adjust if your green is different)
  static const Color primaryGreen = Color(0xFF4CAF50); // Same green as before?
  static const Color iconColor = primaryGreen; // Color for back button etc.

  const CustomAppBar({
    super.key,
    this.showBackButton = true, // Default to show, set false on home page
    this.onProfilePressed,
  });

  @override
  // Use default toolbar height, can be adjusted if needed
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Decide if the back button should be potentially visible
    final bool canGoBack = Navigator.canPop(context);
    final bool displayBackButton = showBackButton && canGoBack;

    return AppBar(
      // Styling to match design (transparent background, no shadow)
      backgroundColor: Colors.transparent, // Match scaffold background
      elevation: 0, // No shadow
      foregroundColor: iconColor, // Sets default color for icons like back arrow

      // Control leading widget explicitly
      automaticallyImplyLeading: false, // We handle the leading widget manually

      // --- Leading Widget (Back Button) ---
      leading: displayBackButton
          ? IconButton(
              // Use iOS style back arrow, looks closer to the design
              icon: const Icon(Icons.arrow_back_ios_new, color: iconColor),
              onPressed: () => Navigator.pop(context),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null, // No leading widget if back button shouldn't be shown

      // --- Title Widget (Logo + Text, Tappable) ---
      title: GestureDetector(
        // onTap: () {
        //   print('NutrifyZero title tapped - Navigating home');
        //   // Navigate to home and remove all previous routes
        //   // Make sure you have a '/home' named route defined in your MaterialApp
        //   Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

        //   // --- Alternative using MaterialPageRoute (if not using named routes) ---
        //   // Navigator.pushAndRemoveUntil(
        //   //   context,
        //   //   MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your actual home screen widget
        //   //   (route) => false,
        //   // );
        // },
        child: Row(
          mainAxisSize: MainAxisSize.min, // Prevent Row from expanding excessively
          children: [
            // --- Placeholder Logo Icon --- Replace with Image.asset if you have logo
            // Icon(
            //   Icons.eco_outlined, // Placeholder icon (leaf/plant/cup?)
            //   color: primaryGreen,
            //   size: 24, // Adjust size as needed
            // ),
            Image.asset(
              'assets/images/nutrify_zero_app_bar.png', // <<< Path to your logo file
              height: 28, // Adjust height as needed
              width: 28,  // Adjust width as needed
              // Optional: You might not need to color a PNG logo this way
              // color: primaryGreen, // Usually only works well for simple icons/logos
            ),
            
            const SizedBox(width: 8), // Spacing between logo and text
            const Text(
              'NutrifyZero',
              style: TextStyle(
                color: primaryGreen, // Green text color
                fontWeight: FontWeight.bold,
                fontSize: 18, // Adjust size as needed
              ),
            ),
          ],
        ),
      ),
      // Center title only if there's no leading widget (optional behavior)
      centerTitle: !displayBackButton,

      // --- Actions (Profile Icon) ---
      actions: [
        Padding(
          // Add padding to move the icon slightly away from the edge
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            tooltip: 'Profile',
            icon: CircleAvatar(
              radius: 18, // Adjust size as needed
              backgroundColor: Colors.grey[200], // Background while image loads
              // --- Placeholder Profile Image --- Replace with user's actual image URL/Asset
              backgroundImage: const NetworkImage('https://placekitten.com/g/200/200'),
              onBackgroundImageError: (exception, stackTrace) {
                 // Optional: Handle image loading error, e.g., show initials
                 print("Error loading profile image: $exception");
              },
            ),
            onPressed: onProfilePressed ?? () {
              print('Profile icon tapped - Navigating to profile');
              // Navigate to profile screen
              // Make sure you have a '/profile' named route defined
              Navigator.pushNamed(context, '/profile');

               // --- Alternative using MaterialPageRoute ---
              // Navigator.push(
              //    context,
              //    MaterialPageRoute(builder: (context) => ProfileScreen()), // Replace with your Profile screen
              // );
            },
          ),
        ),
      ],
    );
  }
}