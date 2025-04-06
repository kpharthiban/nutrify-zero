import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for potential date formatting if needed later
import '../../widgets/custom_app_bar.dart'; // Assuming this exists

class MyRequestScreen extends StatelessWidget {
  final Map<String, dynamic>? requestData; // Make nullable for sample data

  const MyRequestScreen({super.key, this.requestData});

  // Sample data structure (keep for testing)
  static final Map<String, dynamic> sampleData = {
    'id': 'req_123456',
    'location': 'Library Park Corner, Jalan 1, Kuala Lumpur, Malaysia',
    'contact': '011-XXX XXXX', // Changed key to match design/previous forms
    'peopleCount': 15,
    'description': 'Mostly need bottled water and ready-to-eat snacks. '
        'There are usually 10-15 people present between 12 PM and 2 PM',
    'verificationCode': '999-888-777',
    'status': 'active', // Keep for potential future use
    'createdAt': '2023-07-20T10:30:00Z', // Keep for potential future use
  };

  // Helper to build simple Label: Value items
  Widget _buildDetailItem(String label, String value, {int minLines = 1}) {
     // Added minLines parameter for multi-line descriptions
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Add consistent spacing below items
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14, // Slightly smaller label?
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
             value,
             style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.3, // Adjust line height for readability
             ),
            //  minLines: minLines,
             maxLines: (minLines > 1) ? null : 1, // Allow multiple lines if minLines > 1
           ),
        ],
      ),
    );
  }

  // Helper for date formatting (kept in case needed elsewhere)
  String _formatDate(dynamic date) {
     try {
      if (date is String) {
         DateTime? parsedDate = DateTime.tryParse(date);
         return parsedDate != null ? DateFormat('dd/MM/yyyy').format(parsedDate) : 'Invalid date';
      } else if (date is DateTime) {
        return DateFormat('dd/MM/yyyy').format(date);
      }
     } catch (e) {
       print("Error formatting date: $e");
     }
    return 'Unknown date';
  }


  // Placeholder for handling the close request action
  void _handleCloseRequest(BuildContext context, String? requestId) async {
      if (requestId == null) {
         print("Error: Request ID is null.");
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Error: Cannot close request without ID.')),
          );
         return;
      }

      print("Attempting to close request ID: $requestId");
      // TODO: Implement backend call to close/delete the request
      // Example: bool success = await ApiService.closeHelpRequest(requestId);

      // Show confirmation based on success/failure
      // if (success) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Request closed successfully! (Placeholder)'),
             backgroundColor: Colors.green,
            ),
         );
         // Optionally navigate back or refresh state
         Navigator.pop(context);
      // } else {
      //    ScaffoldMessenger.of(context).showSnackBar(
      //      const SnackBar(
      //        content: Text('Failed to close request. Please try again.'),
      //        backgroundColor: Colors.red,
      //       ),
      //    );
      // }
   }


  @override
  Widget build(BuildContext context) {
    // Use provided data or fallback to sample data
    final data = requestData ?? sampleData;
    const Color primaryRed = Color(0xFFE53935); // Consistent red

    // Extract data with type-safe fallbacks
    final location = data['location'] as String? ?? 'N/A';
    // Use 'contact' key consistent with sample data and design hint
    final contact = data['contact'] as String? ?? 'N/A';
    final peopleCount = (data['peopleCount'] as int?)?.toString() ?? 'N/A';
    final description = data['description'] as String? ?? 'N/A';
    final verificationCode = data['verificationCode'] as String? ?? 'N/A';

    return Scaffold(
      appBar: const CustomAppBar(), // Assuming default shows back button
      body: SingleChildScrollView( // Use SingleChildScrollView for long descriptions
         padding: const EdgeInsets.all(20.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // --- Header ---
             const Text(
               'My Request',
               style: TextStyle(
                 fontSize: 26,
                 fontWeight: FontWeight.bold,
                 color: primaryRed, // Red title
               ),
             ),
             const Divider(height: 25, thickness: 1),

             // --- Detail Items ---
              _buildDetailItem('Location:', location),
              _buildDetailItem('Contact Number:', contact), // Label matches design
              _buildDetailItem('Number of people:', peopleCount),
              _buildDetailItem(
                 'Description / More Details:', // Label matches design
                 description,
                 minLines: 3, // Allow description to wrap
               ),
              const SizedBox(height: 20), // Space before Verification Code

              // --- Verification Code ---
              const Text(
                 // Label matches design
                'Verification Code (Provide to Donor):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Container( // Container with red border
                width: double.infinity, // Take full width
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: primaryRed, width: 1.0), // Red border
                  color: Colors.white, // White background inside border
                ),
                child: Text(
                  verificationCode,
                  style: const TextStyle(
                     fontSize: 16,
                     color: Colors.black87, // Black text for code
                     fontWeight: FontWeight.bold,
                   ),
                   textAlign: TextAlign.center, // Center the code
                ),
              ),
             const SizedBox(height: 40), // Space before button

             // --- Close Request Button ---
             Center(
               child: ElevatedButton.icon(
                 onPressed: () => _handleCloseRequest(context, data['id'] as String?),
                  // Exit/Door icon
                 icon: const Icon(Icons.exit_to_app, color: Colors.white),
                 label: const Text('Close Request'),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: primaryRed, // Red background
                   foregroundColor: Colors.white, // White text/icon
                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0), // Rounded button
                   ),
                 ),
               ),
             ),
              const SizedBox(height: 20), // Bottom padding
           ],
         ),
       ),
    );
  }
}