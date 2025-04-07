import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home_screen.dart'; // Navigate here on success

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false; // To show loading indicator

  // Define the primary green color
  static const Color primaryGreen = Color(0xFF4CAF50);

  // --- Google Sign-In Logic ---
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true; // Show loading indicator
    });

    try {
      // Trigger the Google Authentication flow.
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the user cancelled the sign-in
      if (googleUser == null) {
        setState(() { _isSigningIn = false; });
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Sign-In cancelled.')),
         );
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // --- Sign-in successful! ---
      print('Successfully signed in: ${userCredential.user?.displayName}');

      // Navigate to home screen, replacing login screen
      if (mounted) { // Check if widget is still in the tree
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
         );
      }

    } on FirebaseAuthException catch (e) {
       print('Firebase Auth Error: ${e.message}');
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. ${e.message}')),
       );
    } catch (e) {
       print('Google Sign-In Error: $e');
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('An error occurred during sign-in.')),
       );
    } finally {
      // Hide loading indicator only if the widget is still mounted
      if (mounted) {
         setState(() {
           _isSigningIn = false;
         });
      }
    }
  } // --- End Google Sign-In Logic ---


  @override
  Widget build(BuildContext context) {
     // Logo size variable
    const double logoSize = 250.0; // Example: Increased size
    const double logoHeightSize = 150.0;

    return Scaffold(
      backgroundColor: primaryGreen,
      body: SafeArea( // Prevent UI overlap with status bar/notches
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0), // Add some padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(flex: 7), // Push content down slightly

                // --- Logo --- (Using placeholder logic)
                Image.asset(
                  'assets/images/nutrify_zero_logo_white.png', // Replace with your logo path
                  height: logoHeightSize,
                  width: logoSize,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.eco_outlined, color: Colors.white, size: logoSize),
                ),
                const SizedBox(height: 2),

                // --- Tagline ---
                const Text(
                  'Ending Hunger. Together.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Spacer(flex: 2), // Add more space before button

                // --- Google Sign-In Button ---
                _isSigningIn
                  ? const CircularProgressIndicator(color: Colors.white) // Show loading
                  : ElevatedButton.icon(
                       icon: Image.asset( // Google logo from assets
                          'assets/images/google_logo.png', // <<< Add Google logo PNG to assets
                          height: 20.0,
                       ),
                       label: const Text(' Continue with Google'),
                       onPressed: _signInWithGoogle,
                       style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black87, // Text color
                          backgroundColor: Colors.white, // Button background
                          minimumSize: const Size(double.infinity, 50), // Full width
                          shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10.0),
                          ),
                          textStyle: const TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                          ),
                       ),
                    ),
                  const Spacer(flex: 10), // Space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}