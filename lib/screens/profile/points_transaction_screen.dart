import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Assuming this exists

class PointsTransactionScreen extends StatelessWidget {
  const PointsTransactionScreen({super.key}); // Use const constructor

  // Mock transaction data (keep for layout)
  // TODO: Replace with actual data fetching
  final List<Map<String, dynamic>> transactions = const [
    {
      'date': '17/03/2025',
      'activity': 'Food Donation',
      'points': '+500',
      'isPositive': true,
    },
    {
      'date': '16/03/2025',
      'activity': 'Donation to Food Bank',
      'points': '+500',
      'isPositive': true,
    },
     { // Example of points deduction
      'date': '15/03/2025',
      'activity': 'Exchange for Tree Planting',
      'points': '-1000',
      'isPositive': false,
    },
    // Add more transactions as needed
  ];

  // Placeholder for total points
  // TODO: Replace with actual data fetching
  final int totalPoints = 1000;

  // --- Updated Transaction Item Builder ---
  Widget _buildTransactionItem({
    required String date,
    required String activity,
    required String points,
    required bool isPositive,
  }) {
    // Define colors based on transaction type
    final Color pointsColor = isPositive ? Colors.green.shade700 : Colors.red.shade700;

    return ListTile(
      contentPadding: EdgeInsets.zero, // Remove default padding if needed
      leading: Icon(Icons.chevron_right, color: Colors.grey[400]), // Leading chevron
      title: Text(
         activity,
         style: const TextStyle(
             fontSize: 15,
             fontWeight: FontWeight.w600, // Slightly bolder activity
             color: Colors.black87),
       ),
       subtitle: Text( // Date as subtitle
         date,
         style: TextStyle(
           fontSize: 13,
           color: Colors.grey[600],
         ),
       ),
       trailing: Text( // Points on the right
         points,
         style: TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.bold,
           color: pointsColor, // Green for positive, Red for negative
         ),
       ),
       // Optional: Add onTap for navigation to specific transaction details?
       // onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
     // Define colors
    const Color primaryGreen = Color(0xFF4CAF50);
    // Use a blue-grey for title? Adjust shade as needed
    final Color titleColor = Colors.blueGrey.shade700;
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      appBar: const CustomAppBar(), // Assuming default shows back button
      body: Padding(
        // Use symmetric padding, maybe more vertical space
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                'My Points Transaction',
                style: TextStyle(
                  fontSize: 26, // Adjust size
                  fontWeight: FontWeight.bold,
                  color: titleColor, // Use defined title color
                ),
              ),
            ),
            const Divider(height: 16, thickness: 1), // Divider below title

            // --- Updated Points Summary Card ---
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0), // Margin above/below
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
                    const Spacer(), // Pushes points to the right
                    Text(
                       '$totalPoints pts', // Display points
                       style: const TextStyle(
                          fontSize: 26, // Large points text
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                       ),
                    ),
                 ],
              ),
            ),
            const SizedBox(height: 8), // Space before list starts

            // --- Transaction List ---
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                // Use SizedBox for spacing instead of Divider to match design better
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  // Use the updated builder function
                  return _buildTransactionItem(
                    date: transaction['date'],
                    activity: transaction['activity'],
                    points: transaction['points'],
                    isPositive: transaction['isPositive'] ?? false, // Handle potential null
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // No BottomNavBar usually on sub-screens like this
    );
  }
}