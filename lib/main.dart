// In main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/donate/donate_screen.dart';
import 'screens/hunger_map/hunger_map_screen.dart';
import 'screens/food_bank/food_bank_screen.dart';
import 'screens/discover/discover_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/auth/auth_wrapper.dart';
import 'screens/auth/login_screen.dart';
// Import the custom builder if it's in a separate file
// import 'utils/custom_page_transition.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import generated options

void main() async { // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are ready
  await Firebase.initializeApp( // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform, // Use generated options
  );
  runApp(const MyApp()); // Run your app
}

// --- Custom Fade Transition Builder --- (Keep this definition)
class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

// void main() => runApp(const MyApp()); // Use const constructor

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Use const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutrifyZero',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // Define primaryGreen globally if desired
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),

        // --- Add Page Transitions Theme ---
        pageTransitionsTheme: const PageTransitionsTheme(
          // Override transitions for specific platforms (or all)
          builders: {
            // Apply Fade transition to Android
            TargetPlatform.android: FadePageTransitionsBuilder(),
            // Apply Fade transition to iOS
            TargetPlatform.iOS: FadePageTransitionsBuilder(),
            // Add for other platforms if needed (macOS, windows, linux)
             TargetPlatform.macOS: FadePageTransitionsBuilder(),
             TargetPlatform.windows: FadePageTransitionsBuilder(),
             TargetPlatform.linux: FadePageTransitionsBuilder(),
          },
        ),
        // --- End Page Transitions Theme ---
        // --- ADD/MODIFY THIS LINE ---
        // Set the desired duration for page transitions
        // Default is ~300ms. Try shorter values like 150ms or 200ms.
        // transitionDuration: const Duration(milliseconds: 200), // e.g., 200 milliseconds
        // useMaterial3: true, // Enable Material 3 if desired
      ),

      // Keep SplashScreen as home
      home: const SplashScreen(),

      // Keep your named routes
      routes: {
        // Make sure routes map to const constructors if possible
        // '/': (context) => const AuthWrapper(), // Example root route
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(), // <<< Add this route
        '/donate': (context) => const DonateScreen(),
        '/hungermap': (context) => const HungerMapScreen(),
        '/foodbank': (context) => const FoodBankScreen(),
        '/discover': (context) => const DiscoverScreen(),
        '/profile': (context) => const ProfileScreen(),
        // Add initial route like '/' if needed, maybe pointing to home or splash?
        // '/': (context) => const SplashScreen(), // If using initialRoute instead of home
      },
      // initialRoute: '/', // Use either home or initialRoute
    );
  }
}

