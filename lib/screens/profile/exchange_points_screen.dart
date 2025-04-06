import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Assuming exists

// Data structure for exchange options (optional but cleaner)
class ExchangeOption {
  final String reward; // e.g., "1 Tree", "5 Trees"
  final String rewardDescription; // e.g., "We help you to Plant 1 Tree"
  final String pointsDisplay; // e.g., "1000 pts"
  final int pointsRequired; // e.g., 1000
  final IconData iconData; // Icon for the card

  const ExchangeOption({
    required this.reward,
    required this.rewardDescription,
    required this.pointsDisplay,
    required this.pointsRequired,
    required this.iconData,
  });
}

class ExchangePointsScreen extends StatelessWidget {
  const ExchangePointsScreen({super.key}); // Use const constructor

  // --- Placeholder Data --- (Replace with actual data fetching)
  final int currentPoints = 1000;
  final List<ExchangeOption> exchangeOptions = const [
    ExchangeOption(
      reward: '1 Tree',
      rewardDescription: 'We help you to Plant 1 Tree',
      pointsDisplay: '1000 pts',
      pointsRequired: 1000,
      iconData: Icons.park_outlined, // Placeholder tree icon
    ),
    ExchangeOption(
      reward: '5 Trees',
      rewardDescription: 'We help you to Plant 5 Trees',
      pointsDisplay: '5000 pts',
      pointsRequired: 5000,
      iconData: Icons.forest_outlined, // Placeholder forest icon
    ),
    // Add more options here
  ];
  // --- End Placeholder Data ---


  // --- Helper for the new Green Exchange Cards ---
  Widget _buildGreenExchangeCard(BuildContext context, ExchangeOption option) {
    const Color primaryGreen = Color(0xFF4CAF50);

    // Check if user has enough points (basic check)
    // TODO: Implement more robust check, considering state if points update after exchange
    final bool canAfford = currentPoints >= option.pointsRequired;
    final Color cardColor = canAfford ? primaryGreen : Colors.grey.shade400; // Dim if cannot afford
    final Color textColor = canAfford ? Colors.white : Colors.white.withOpacity(0.7);

    return GestureDetector(
      // Only allow tap if user can afford it
      onTap: canAfford
          ? () => _showExchangeConfirmation(
                context,
                reward: option.reward,
                pointsRequired: option.pointsRequired,
              )
          : null, // Disable tap if not affordable
      child: Opacity( // Visually indicate disabled state
        opacity: canAfford ? 1.0 : 0.6,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: cardColor, // Use determined color
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(option.iconData, size: 32, color: textColor), // White icon
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.rewardDescription, // Main text
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.pointsDisplay, // Points text
                      style: TextStyle(
                        color: textColor.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
               // Optional: Add arrow or indicator if needed
               // Icon(Icons.chevron_right, color: textColor),
            ],
          ),
        ),
      ),
    );
  } // --- End of _buildGreenExchangeCard ---


   // --- Confirmation Dialog Logic --- (Keep as is)
  void _showExchangeConfirmation(
    BuildContext context, {
    required String reward,
    required int pointsRequired,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exchange'),
        content: Text('Exchange $pointsRequired points to plant $reward?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Confirm', style: TextStyle(color: Color(0xFF4CAF50))), // Use primaryGreen
            onPressed: () {
               print('Exchange confirmed for $reward');
               // TODO: Implement points deduction logic HERE
               // Example: bool success = await PointService.deductPoints(pointsRequired);
               // if (success) {
               //    Navigator.pop(context); // Close dialog FIRST
               //    _showSuccessMessage(context, reward: reward);
               //    // TODO: Refresh user points display (might require converting to StatefulWidget)
               // } else { // Handle failure }

               // --- Temporary logic ---
               Navigator.pop(context); // Close dialog
              _showSuccessMessage(context, reward: reward);
               // --- End temporary logic ---
            },
          ),
        ],
      ),
    );
  }

  // --- Success Message Logic --- (Keep as is)
  void _showSuccessMessage(BuildContext context, {required String reward}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you! You helped plant $reward! 🌳'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4), // Slightly shorter?
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
     // --- Define Colors ---
    const Color primaryGreen = Color(0xFF4CAF50);

    return Scaffold(
      appBar: const CustomAppBar(), // Assuming default shows back button
      body: SingleChildScrollView( // Allow content to scroll if needed
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            const Padding(
               padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
               child: Text(
                  'Exchange Points',
                  style: TextStyle(
                    fontSize: 28, // Adjust size
                    fontWeight: FontWeight.bold,
                    color: primaryGreen, // Green title
                  ),
                ),
            ),
            const Divider(height: 16, thickness: 1), // Divider below title

            // --- Points Summary Card --- (Reusing style from Profile)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12.0),
                 border: Border.all(color: primaryGreen, width: 1.5), // Green border
              ),
              child: Row(
                 children: [
                    const Text(
                       'My Points',
                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
                    const Spacer(),
                    Text(
                       '$currentPoints pts', // Display points
                       style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                       ),
                    ),
                 ],
              ),
            ),
            const SizedBox(height: 16), // Space before exchange options

            // --- Exchange Options List ---
            // Removed "We help you to Plant" header text
            // Build cards from the list
            Column(
              children: exchangeOptions
                  .map((option) => _buildGreenExchangeCard(context, option))
                  .toList(),
            ),

            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
       // No BottomNavBar usually on sub-screens like this
    );
  }
}