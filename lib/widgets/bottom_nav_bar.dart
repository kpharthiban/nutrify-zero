import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int? currentIndex; // Nullable index

  // Define colors (adjust if your green is different)
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color unselectedColor = Colors.black54; // Or Colors.grey[700]

  const CustomBottomNavBar({super.key, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // Use a default index if none is provided (e.g., for initial load)
    int effectiveCurrentIndex = currentIndex ?? 0;

    return BottomNavigationBar(
      currentIndex: effectiveCurrentIndex,
      type: BottomNavigationBarType.fixed, // Ensures labels are always shown
      backgroundColor: Colors.white, // Optional: Set background color
      selectedItemColor: primaryGreen, // Color for selected icon and label
      unselectedItemColor: unselectedColor, // Color for unselected items

      // Adjust font sizes if needed (design looks relatively small)
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,

      // Increase overall spacing/height by slightly increasing icon size
      // and adding padding around the icon if needed.
      // The BottomNavigationBar has a default height, but these help internally.
      iconSize: 26.0, // Slightly larger icons

      // Setting these ensures labels are always visible, consistent with design
      showSelectedLabels: true,
      showUnselectedLabels: true,

      items: [
        // Donate Item
        BottomNavigationBarItem(
          // --- Placeholder Icon --- Replace with your custom icon if available
          icon: const Padding(
            // Increase top/bottom padding for more vertical space
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.volunteer_activism_outlined, size: 28), // Slightly larger icon too
          ),
          activeIcon: const Padding( // Optional: Use filled icon when active
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.volunteer_activism, size: 28), // 
          ),
          label: 'Donate',
        ),

        // HungerMap Item
        BottomNavigationBarItem(
          // --- Placeholder Icon ---
          icon: const Padding(
            // Increase top/bottom padding for more vertical space
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.explore_outlined, size: 28), // Slightly larger icon too
          ),
          activeIcon: const Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.explore, size: 28), // 
          ),
          label: 'HungerMap',
        ),

        // Food Bank Item
        BottomNavigationBarItem(
          // --- Placeholder Icon ---
          icon: const Padding(
            // Increase top/bottom padding for more vertical space
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.inventory_2_outlined, size: 28), // Slightly larger icon too
          ),
          activeIcon: const Padding(
             padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.inventory_2, size: 28), // 
          ),
          label: 'Food Bank',
        ),

        // Discover Item
        BottomNavigationBarItem(
           // --- Placeholder Icon --- This one is hard to match, 'search' is generic
          icon: const Padding(
            // Increase top/bottom padding for more vertical space
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.search, size: 28), // Slightly larger icon too
          ),
           activeIcon: const Padding( // Optional: use same icon or slightly different one
             padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(Icons.search, size: 28), // bolder maybe?
          ),
          label: 'Discover',
        ),
      ],

      // Keep your existing navigation logic
      onTap: (index) {
        // Only navigate if a different tab is selected
        if (currentIndex != index) {
          // Use pushReplacementNamed to avoid building up the navigation stack
          switch (index) {
            case 0:
              // Check if already on /donate before pushing? Depends on desired stack behavior
              Navigator.pushReplacementNamed(context, '/donate');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/hungermap');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/foodbank');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/discover');
              break;
          }
        }
      },
    );
  }
}