import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For setting status bar color etc. (optional)
import 'auth/auth_wrapper.dart';

// Import your main screen (e.g., home screen) to navigate to
// import 'home_screen.dart'; // Adjust path if necessary

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Define the primary green color (ensure consistency)
  static const Color primaryGreen = Color(0xFF4CAF50);
  // Define splash screen duration
  static const splashDuration = Duration(seconds: 1);
  // Define fade transition duration
  static const transitionDuration = Duration(milliseconds: 500); // 0.5 seconds

  @override
  void initState() {
    super.initState();
    _navigateToHome(); // Start the timer to navigate away
  }

  // Function to handle delayed navigation with fade transition
  void _navigateToHome() async {
    // Wait for the splash screen duration
    await Future.delayed(splashDuration, () {});

    // Ensure the widget is still mounted before navigating
    if (mounted) {
      // Navigate to the HomeScreen using a Fade Transition
      Navigator.pushReplacement(
        context,
        // Go to AuthWrapper instead of HomeScreen directly
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optional: Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryGreen, // Or Colors.transparent
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // --- Define a LARGER logo size ---
    // *** Adjust this value to fit your design ***
    const double logoSize = 250.0; // Example: Increased size
    const double logoHeightSize = 150.0;

    return Scaffold(
      backgroundColor: primaryGreen, // Set the background color
      body: Center( // Center the content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center column content vertically
          children: <Widget>[
            // --- Only the Logo --- (Removed the Row and Text)
            Image.asset(
               'assets/images/nutrify_zero_logo_white.png', // <<< Make sure path is correct
               height: logoHeightSize, // Use the larger size
               width: logoSize,  // Use the larger size
               errorBuilder: (context, error, stackTrace) {
                 // Fallback if image fails
                 print("Error loading splash logo: $error");
                 return Icon(Icons.eco_outlined, color: Colors.white, size: logoSize);
               },
            ),
            const SizedBox(height: 8), // Increased space below logo

            // --- Tagline ---
            const Text(
              'Ending Hunger. Together.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}