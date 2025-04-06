import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Adjust path if needed
import 'food_bank_details_screen.dart';
// Import details screen later if needed:
// import 'food_bank_details_screen.dart';

// --- Data Model ---
class FoodBank {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String description;
  final bool addedByUser;
  final String? verificationCode; // Added nullable verification code

  FoodBank({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    this.addedByUser = false,
    this.verificationCode, // Add to constructor
  });
}

// Update the dummy data list in FoodBanksListScreen class
class FoodBanksListScreen extends StatelessWidget {
  FoodBanksListScreen({super.key});

  final List<FoodBank> foodBanks = [
    FoodBank(
      id: 'fb-001',
      name: 'Neighborhood Food Share',
      address: 'Sentul, Kuala Lumpur, Malaysia.',
      phone: '011-XXX XXXX',
      description: 'Specific Needs: Dry goods, spices, and cooking ingredients.\nOpen Tuesdays and Thursdays, 3 PM - 6 PM.\nAdditional Notes: Operated by local volunteers, focusing on reducing food waste.',
      // verificationCode is null by default
    ),
    FoodBank(
      id: 'fb-002',
      name: 'Charity Food Hub',
      address: 'Bangsar, Kuala Lumpur, Malaysia.',
      phone: '011-XXX XXXX',
      addedByUser: true, // This one is added by user
      description: 'Specific Needs: Halal-certified meals, dates, and drinks.\nOpen daily during Ramadan, 6 PM - 10 PM.\nAlso open every Sunday 10am to 2pm.\nAdditional Notes: Provides hot meals and groceries to low-income families and individuals.', // Updated example description
      verificationCode: '777-888-999', // Add sample verification code
    ),
    FoodBank(
      id: 'fb-003',
      name: 'Community Pantry Project',
      address: 'Setapak, Kuala Lumpur, Malaysia.',
      phone: '011-XXX XXXX',
      description: 'Specific Needs: Fresh produce and bread.\nOpen Weekends 9 AM - 12 PM.\nAccepts monetary donations via QR code on site.',
      // verificationCode is null by default
    ),
  ];

  // --- Reusable Food Bank Card Builder Method ---
  Widget _buildFoodBankCard(BuildContext context, FoodBank foodBank) {
    // Define colors based on the design
    const Color primaryGreen = Color(0xFF4CAF50); // Main green color
    const Color darkGreyText = Color(0xFF616161);

    return InkWell( // Wrap with InkWell for tap effect (for future navigation)
      onTap: () {
        // Navigate to the details screen, passing the selected food bank
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodBankDetailsScreen(foodBank: foodBank), // Pass data
          ),
        );
        // print('Tapped on Food Bank: ${foodBank.name}'); // Old code
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryGreen, width: 1.5), // Green border
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Combine Name and Address for display similar to HungerSpot list
                  Text(
                    '${foodBank.name}, ${foodBank.address}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: primaryGreen, // Use primary green color
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    foodBank.phone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: darkGreyText,
                    ),
                  ),
                  if (foodBank.addedByUser) ...[ // Conditionally show "Added by me"
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
              color: primaryGreen, // Use primary green color
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50); // Main green color
    const Color lightGreyBackground = Color(0xFFF0F0F0); // For search bar

    return Scaffold(
      // Assuming CustomAppBar shows 'NutrifyZero' and handles back/profile icons
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Screen Title ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              'List of Food Banks', // Updated Title
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryGreen, // Use primary green color
              ),
            ),
          ),

          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              // Add controller and onChanged later for functionality
              decoration: InputDecoration(
                hintText: 'Search for location',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: lightGreyBackground, // Light grey background
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
                   // Optionally add a subtle border on focus
                  borderSide: BorderSide(color: primaryGreen, width: 1.0),
                ),
              ),
            ),
          ),

          // --- List of Food Banks ---
          Expanded( // Make the ListView take remaining space
            child: ListView.builder(
              itemCount: foodBanks.length, // Use the length of the list
              itemBuilder: (context, index) {
                // Call the reusable card builder method
                return _buildFoodBankCard(context, foodBanks[index]);
              },
            ),
          ),
        ],
      ),
      // Assuming your main app structure handles the BottomNavigationBar
      // bottomNavigationBar: CustomBottomNavBar(currentIndex: 2), // If needed here
    );
  }
}