import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Assuming this exists and works
import 'spot_details_screen.dart';

// Dummy data class (or you can use a Map)
class HungerSpot {
  final String id;
  final String location;
  final String phone;
  final int numberOfPeople;
  final String description;
  final bool addedByUser;
  final String? verificationCode; // Added nullable verification code

  HungerSpot({
    required this.id,
    required this.location,
    required this.phone,
    required this.numberOfPeople,
    required this.description,
    this.addedByUser = false,
    this.verificationCode, // Add to constructor
  });
}

// Update the dummy data list in SpotsListScreen class
class SpotsListScreen extends StatelessWidget {
  SpotsListScreen({super.key});

  final List<HungerSpot> spots = [
    HungerSpot(
      id: 'hs-001',
      location: 'Library Park Corner, Jalan 1, Kuala Lumpur, Malaysia.',
      phone: '011-XXX XXXX',
      numberOfPeople: 15,
      description: 'Mostly need bottled water and ready-to-eat snacks. There are usually 10-15 people present between 12 PM and 2 PM.',
      // verificationCode is null by default
    ),
    HungerSpot(
      id: 'hs-002',
      location: 'Downtown Shelter Entrance, Jalan 2, Kuala Lumpur, Malaysia.',
      phone: '011-XXX XXXX',
      addedByUser: true, // This one is added by user
      numberOfPeople: 8,
      description: 'Needs blankets and basic toiletries. Usually active in the evenings.',
      verificationCode: '999-888-777', // Add sample verification code
    ),
    HungerSpot(
      id: 'hs-003',
      location: 'Community Hall Block B, Jalan 3, Kuala Lumpur, Malaysia.',
      phone: '011-XXX XXXX',
      numberOfPeople: 25,
      description: 'Hot meals preferred. Gathering point around 6 PM daily.',
      // verificationCode is null by default
    ),
  ];

  // --- Reusable Spot Card Builder Method ---
  // This method builds the individual card for each spot.
  // It's kept private within this file as requested.
  Widget _buildSpotCard(BuildContext context, HungerSpot spot) {
    const Color primaryRed = Color(0xFFE53935);
    const Color darkGreyText = Color(0xFF616161);

    return InkWell( // <-- Wrap with InkWell for tap effect
      onTap: () {
        // Navigate to the details screen, passing the selected spot
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpotDetailsScreen(spot: spot), // Pass spot data
          ),
        );
      },
      child: Container( // <-- Original card container
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryRed, width: 1.5),
          boxShadow: [ /* ... */ ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.location,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: primaryRed, // Use primary color for location
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    spot.phone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: darkGreyText, // Use darker grey for phone
                    ),
                  ),
                  if (spot.addedByUser) ...[ // Conditionally show "Added by me"
                    const SizedBox(height: 6.0),
                    const Text(
                      '*Added by me',
                      style: TextStyle(
                        fontSize: 12,
                        color: darkGreyText,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(width: 10), // Spacing before the icon
            const Icon(
              Icons.chevron_right,
              color: primaryRed, // Use primary color for icon
              size: 30,
            ),
          ],
        ),
      )
    );
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935); // Define again for consistency
    const Color lightGrey = Color(0xFFF5F5F5); // Background for search

    return Scaffold(
      // Assuming CustomAppBar shows the title 'NutrifyZero' and back button etc.
      // If CustomAppBar only takes text, you might need to adjust it or use a standard AppBar
      appBar: CustomAppBar(), // Or adjust as needed
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Screen Title ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              'List of HungerSpots',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryRed, // Match title color
              ),
            ),
          ),

          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for location',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: lightGrey, // Light grey background
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Rounded corners
                  borderSide: BorderSide.none, // No border line
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none, // Or maybe a subtle border on focus
                ),
              ),
              // Add controller and onChanged logic later for search functionality
            ),
          ),

          // --- List of Spots ---
          Expanded( // Make the ListView take remaining space
            child: ListView.builder(
              itemCount: spots.length, // Use the length of your spots list
              itemBuilder: (context, index) {
                // Call the reusable card builder method
                return _buildSpotCard(context, spots[index]);
              },
            ),
          ),
        ],
      ),
      // Assuming your main app structure handles the BottomNavigationBar
      // bottomNavigationBar: BottomNavBar(), // If needed here
    );
  }
}