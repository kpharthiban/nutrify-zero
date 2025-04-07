import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to Firebase Auth state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If user is logged in, show HomeScreen
        else if (snapshot.hasData && snapshot.data != null) {
          print('User is logged in: ${snapshot.data!.uid}');
          return const HomeScreen();
        }
        // If user is not logged in, show LoginScreen
        else {
          print('User is logged out.');
          return const LoginScreen();
        }
        // Optional: Handle errors
        // else if (snapshot.hasError) { ... }
      },
    );
  }
}