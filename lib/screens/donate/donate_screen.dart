import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker

// Assuming these widgets exist at these paths, adjust if necessary
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_app_bar.dart';

// Import the target screens for navigation
import 'make_list_screen.dart';
// Removed ScanScreen import as it's no longer used for navigation here
// import 'scan_screen.dart';
import '../hunger_map/hunger_map_screen.dart'; // Adjust path if needed
import '../food_bank/food_bank_screen.dart'; // Adjust path if needed

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  // --- Helper for the top Green Action Boxes (Scan, Make a List) ---
  Widget _buildGreenActionBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    const Color primaryGreen = Color(0xFF4CAF50); // Consistent green

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 12),
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
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper for the bottom Colored Navigation Cards (HungerMap, Food Bank) ---
  Widget _buildColorNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Widget targetScreen, // Pass the screen widget directly
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => targetScreen), // Navigate to the screen
      ),
      child: Container(
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
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
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
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // --- Function to handle picking image from camera ---
  Future<void> _scanWithCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      // Launch the camera
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        // Optional: imageQuality: 80, maxWidth: 1080,
      );

      if (pickedFile != null) {
        // Image successfully captured
        print('Image picked from camera: ${pickedFile.path}');
        // TODO: Handle the captured image file (send to AI, navigate, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image captured: ${pickedFile.path} (Placeholder)')),
        );
      } else {
        // User cancelled the camera
        print('User cancelled camera.');
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera cancelled.')),
        );
      }
    } catch (e) {
       print('Error picking image from camera: $e');
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing camera: $e')),
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    // Define colors from the design
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color primaryRed = Color(0xFFE53935);
    const Color textColor = Colors.black87;
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      // Assuming CustomAppBar exists and shows 'NutrifyZero' and profile icon
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Header ---
            const Text(
              'Donate', // Main Title
              style: TextStyle(
                fontSize: 32, // Larger title
                fontWeight: FontWeight.bold,
                color: primaryGreen, // Green color
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'food for those in need.',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 12),
            Text(
              'Let AI help you find where to donate!',
              style: TextStyle(fontSize: 14, color: subtitleColor),
            ),
            const SizedBox(height: 24),

            // --- Section 2: Action Buttons (Scan & Make a List) ---
            Row(
              children: [
                Expanded(
                  child: _buildGreenActionBox(
                    icon: Icons.camera_alt_outlined, // Camera icon
                    title: 'Scan',
                    subtitle: 'food or leftover items available to donate',
                    onPressed: () => _scanWithCamera(context), // Call image picker
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGreenActionBox(
                    icon: Icons.list_alt, // List icon
                    title: 'Make a List',
                    subtitle: 'of food or leftover items available to donate',
                    onPressed: () => Navigator.push( // Navigate to MakeListScreen
                      context,
                      MaterialPageRoute(builder: (_) => const MakeListScreen()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30), // Spacing

            // --- Section 3: Navigation Cards ---
            Text(
              'Head over to these sections to explore where you can donate!',
              style: TextStyle(fontSize: 15, color: subtitleColor),
            ),
            const SizedBox(height: 16),
            // HungerMap Navigation Card
            _buildColorNavigationCard(
              context: context,
              icon: Icons.map_outlined, // Map icon
              title: 'HungerMap',
              subtitle: 'Find those in need to donate food',
              backgroundColor: primaryRed, // Red background
              targetScreen: HungerMapScreen(), // Navigate to HungerMapScreen Widget
            ),
            const SizedBox(height: 12),
            // Food Bank Navigation Card
            _buildColorNavigationCard(
              context: context,
              icon: Icons.store_outlined, // Store/Food bank icon
              title: 'Food Bank',
              subtitle: 'Search food banks to donate food',
              backgroundColor: primaryGreen, // Green background
              targetScreen: FoodBankScreen(), // Navigate to FoodBankScreen Widget
            ),
            const SizedBox(height: 20), // Padding at the bottom
          ],
        ),
      ),
       // Assuming CustomBottomNavBar exists and takes currentIndex
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0), // Donate tab active
    );
  }
}