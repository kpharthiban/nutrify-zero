// File: lib/screens/donate/make_list_screen.dart (Adjust path if needed)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For number input formatter

// Import shared widgets (Adjust path if necessary)
import '../../widgets/custom_app_bar.dart';

// Import AI suggestion components when ready (Adjust path if necessary)
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';

// Data structure for a single item row
class DonationItem {
  final TextEditingController foodNameController;
  final TextEditingController quantityController;

  // Default constructor for adding empty rows manually
  DonationItem()
      : foodNameController = TextEditingController(),
        quantityController = TextEditingController();

  // Constructor with initial values (used when coming from ScanScreen)
  DonationItem.withValues({String initialFood = '', String initialQuantity = ''})
      : foodNameController = TextEditingController(text: initialFood),
        quantityController = TextEditingController(text: initialQuantity);


  // Helper to dispose controllers
  void dispose() {
    foodNameController.dispose();
    quantityController.dispose();
  }
}


class MakeListScreen extends StatefulWidget {
  // Optional parameter to receive initial items from ScanScreen
  final List<Map<String, String>>? initialItems;

  const MakeListScreen({super.key, this.initialItems});

  @override
  State<MakeListScreen> createState() => _MakeListScreenState();
}


class _MakeListScreenState extends State<MakeListScreen> {
  // Initialize list here, will be potentially overwritten in initState
  final List<DonationItem> _items = [];

  // Controller for preferred location
  final _locationController = TextEditingController();

  // Form key for potential validation
  final _formKey = GlobalKey<FormState>();

  // State variable for AI location finding loading state
  bool _isFindingLocation = false;
  // String _aiSuggestions = ""; // Uncomment if displaying suggestions directly

  @override
  void initState() {
    super.initState();
    // Check if initial items were passed (e.g., from ScanScreen)
    if (widget.initialItems != null && widget.initialItems!.isNotEmpty) {
      // Populate the list from the passed data
      print("MakeListScreen received initial items: ${widget.initialItems}");
      for (var itemData in widget.initialItems!) {
        // Use the constructor that takes initial values
        _items.add(DonationItem.withValues(
          initialFood: itemData['food'] ?? '', // Use null-aware default
          initialQuantity: itemData['quantity'] ?? '',
        ));
      }
    } else {
      // If no initial items, start with one empty row by default
      print("MakeListScreen started with no initial items, adding one empty row.");
      _items.add(DonationItem());
    }
  } // --- End initState ---


  @override
  void dispose() {
    // Dispose all item controllers
    for (var item in _items) {
      item.dispose();
    }
    // Dispose location controller
    _locationController.dispose();
    super.dispose();
  }

  // Function to add a new empty item row
  void _addItemRow() {
    setState(() {
      _items.add(DonationItem());
    });
  }

  // Function to remove an item row
  void _removeItemRow(int index) {
    if (_items.length > 1) {
      // Make sure to dispose controllers before removing the item from the list
      _items[index].dispose();
      setState(() {
        _items.removeAt(index);
      });
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot remove the last item.")),
      );
    }
  }

  // Function to handle the AI button press (Find Location)
  Future<void> _findLocationAI() async {
     // Basic form validation (optional)
     // You might want to validate item names/quantities here if needed
     // if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;
    setState(() { _isFindingLocation = true; }); // Show loading

    // --- Gather Input Data ---
    final List<Map<String, String>> itemListData = _items
        .map((item) => {
              'food': item.foodNameController.text.trim(),
              'quantity': item.quantityController.text.trim(),
            })
        .where((item) => item['food']!.isNotEmpty) // Filter out rows where food name is empty
        .toList();

    final String preferredLocationText = _locationController.text.trim();

     if (itemListData.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Please add at least one food item.')),
       );
       if (mounted) setState(() { _isFindingLocation = false; });
       return;
     }

    print('--- Finding Location (AI) ---');
    print('Items: $itemListData');
    print('Preferred Location: $preferredLocationText');
    print('----------------------------');

    // --- Placeholder for API Call & Result Handling ---
    // TODO: Implement Firestore fetch + Gemini Text API call logic here
    // This involves:
    // 1. Fetching potential spots (hungerSpots, foodBanks) from Firestore,
    //    ideally using geoquery based on preferredLocationText (requires geocoding)
    //    or fetching all for simplicity initially.
    // 2. Constructing a detailed prompt for Gemini Text model including the
    //    itemListData, preferredLocationText, and fetched spots data (with needs/descriptions).
    // 3. Calling the Gemini API using the 'google_generative_ai' package.
    // 4. Parsing the response.
    // 5. Displaying the suggestions.

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Example: Display dummy suggestions after delay
    String suggestionsResult = "AI Suggestions Placeholder:\n"
                               "1. Cyberjaya Food Hub (Near your area, accepts general items)\n"
                               "2. Community Fridge @ MMU (Good for ready-to-eat)\n"
                               "3. AskForHelp Request #123 (Specific need: Apples)";

     if (mounted) {
       setState(() { _isFindingLocation = false; }); // Hide loading indicator

        // Show results in a dialog for now
        showDialog(
             context: context,
             builder: (dialogContext) => AlertDialog( // Use dialogContext
                 title: const Text("Suggested Donation Spots"),
                 content: SingleChildScrollView(child: Text(suggestionsResult)),
                 actions: [
                     TextButton(
                         child: const Text("OK"),
                         onPressed: () => Navigator.pop(dialogContext), // Use dialogContext
                     )
                 ],
             ),
         );
     }
     // --- End Placeholder ---

  } // --- End _findLocationAI ---


    // Helper for styled TextFormFields
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
     String? Function(String?)? validator,
     int maxLines = 1,
  }) {
     const Color lightGreyBackground = Color(0xFFF0F0F0); // Light grey background
     return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            filled: true,
            fillColor: lightGreyBackground,
            border: OutlineInputBorder( // Use OutlineInputBorder for consistent shape
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none, // No visible border line
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
             focusedBorder: OutlineInputBorder( // Subtle border on focus
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0), // Adjust padding
        ),
         validator: validator,
     );
  } // --- End _buildStyledTextField ---


  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      // Use CustomAppBar (ensure it's imported)
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- Header ---
                const Text(
                  'Make a List',
                  style: TextStyle( fontSize: 26, fontWeight: FontWeight.bold, color: primaryGreen ),
                ),
                const SizedBox(height: 4),
                Text(
                  'of food or leftover items available to donate.',
                   style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
                const Divider(height: 25, thickness: 1),

                // --- Dynamic Food Item List ---
                const Text(
                  'List all the food items you want to donate:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                // Build rows dynamically using ListView.builder
                ListView.builder(
                  shrinkWrap: true, // Essential within SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Disable nested scrolling
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    // --- List Item Row ---
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align items if they wrap
                        children: [
                          // Food Item Field
                          Expanded(
                            flex: 3, // More space for item name
                            child: _buildStyledTextField(
                              controller: _items[index].foodNameController,
                              hintText: 'Food item',
                              validator: (value) {
                                // Basic validation: required only if quantity is also entered?
                                // Or just ensure it's not empty if it's not the only row?
                                // Let's keep it simple: required if not the only row, or if qty is filled
                                final qty = _items[index].quantityController.text.trim();
                                if ((_items.length > 1 || qty.isNotEmpty) && (value == null || value.trim().isEmpty)) {
                                   return 'Required';
                                }
                                return null;
                              }
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Quantity Field
                          Expanded(
                             flex: 1, // Less space for quantity
                             child: _buildStyledTextField(
                                controller: _items[index].quantityController,
                                hintText: 'Qty',
                                keyboardType: TextInputType.text, // Allow "1 loaf", "500g" etc.
                                inputFormatters: null, // No specific formatter
                                 validator: (value) {
                                  // Optional validation for quantity
                                  // if (value == null || value.trim().isEmpty) {
                                  //    return 'Req.';
                                  // }
                                  return null;
                                 }
                             ),
                          ),
                          // Remove Button (Shows only if more than one item)
                          if (_items.length > 1)
                             Padding(
                               padding: const EdgeInsets.only(left: 4.0, top: 4.0), // Adjust alignment slightly
                               child: IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Colors.red[400]),
                                  onPressed: () => _removeItemRow(index),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Remove item',
                               ),
                             )
                          else
                             const SizedBox(width: 48) // Keep space consistent
                        ],
                      ),
                    );
                  },
                ), // --- End ListView.builder ---

                // --- Add More Button ---
                Align( // Align button slightly right (optional style)
                   alignment: Alignment.centerLeft,
                   child: TextButton.icon(
                      icon: const Icon(Icons.add_circle_outline, color: primaryGreen, size: 20),
                      label: const Text(
                        'Add more food item',
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      onPressed: _addItemRow,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0), // Reduce padding
                      ),
                   ),
                ),
                const SizedBox(height: 24),

                // --- Location Preference ---
                const Text(
                  'What is your preferred location to donate?',
                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                 Row( // Row to hold TextField and dropdown icon
                  children: [
                    Expanded(
                      child: _buildStyledTextField(
                         controller: _locationController,
                         hintText: 'Enter the location (e.g., street, area)',
                         validator: (value) {
                            // Make location optional or required based on your needs
                            // if (value == null || value.trim().isEmpty) {
                            //   return 'Please enter a preferred location';
                            // }
                            return null; // Currently optional
                         }
                      ),
                    ),
                    // Visual dropdown arrow only
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- AI Button ---
                Center(
                  child: _isFindingLocation // Check loading state
                    ? const CircularProgressIndicator(color: primaryGreen) // Show loading indicator
                    : ElevatedButton.icon(
                        onPressed: _findLocationAI, // Call the function
                        icon: const Icon(Icons.search, color: Colors.white, size: 20),
                        label: const Text('Find Location to Donate (AI)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 20), // Bottom padding

              ], // End main Column children
            ),
          ),
        ),
      ),
    );
  }
} // --- End _MakeListScreenState ---