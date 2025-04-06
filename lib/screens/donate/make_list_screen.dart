import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For number input formatter
import '../../widgets/custom_app_bar.dart'; // Assuming this exists

// Data structure for a single item row
class DonationItem {
  final TextEditingController foodNameController;
  final TextEditingController quantityController;

  DonationItem()
      : foodNameController = TextEditingController(),
        quantityController = TextEditingController();

  // Helper to dispose controllers
  void dispose() {
    foodNameController.dispose();
    quantityController.dispose();
  }
}

class MakeListScreen extends StatefulWidget {
  const MakeListScreen({super.key});

  @override
  State<MakeListScreen> createState() => _MakeListScreenState();
}

class _MakeListScreenState extends State<MakeListScreen> {
  // List to hold controllers for each item row
  final List<DonationItem> _items = [DonationItem()]; // Start with one item

  // Controller for preferred location
  final _locationController = TextEditingController();

  // Form key for potential validation
  final _formKey = GlobalKey<FormState>();

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

  // Function to add a new item row
  void _addItemRow() {
    setState(() {
      _items.add(DonationItem());
    });
  }

  // Function to remove an item row (optional, added for usability)
  void _removeItemRow(int index) {
    // Prevent removing the last item
    if (_items.length > 1) {
      setState(() {
        _items[index].dispose(); // Dispose controllers of the removed item
        _items.removeAt(index);
      });
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot remove the last item.")),
      );
    }
  }

  // Function to handle the AI button press
  void _findLocationAI() {
    // Basic validation example (optional)
    // if (!_formKey.currentState!.validate()) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please fill in all item details.')),
    //   );
    //   return;
    // }

    // Gather data
    final List<Map<String, String>> itemListData = _items.map((item) {
      return {
        'food': item.foodNameController.text,
        'quantity': item.quantityController.text,
      };
    }).toList();

    final String preferredLocation = _locationController.text;

    print('--- Finding Location (AI) ---');
    print('Items: $itemListData');
    print('Preferred Location: $preferredLocation');
    print('----------------------------');

    // TODO: Implement API call to backend/AI service here
    // Send itemListData and preferredLocation
    // Handle response and maybe navigate to a results screen

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding donation locations... (placeholder)')),
    );
  }

    // Helper for styled TextFormFields
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
     String? Function(String?)? validator,
  }) {
     const Color lightGreyBackground = Color(0xFFF0F0F0);
     return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            filled: true,
            fillColor: lightGreyBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
             focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        ),
         validator: validator,
     );
  }


  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      appBar: CustomAppBar(), // Use your app bar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form( // Wrap form around potentially validated fields
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- Header ---
                const Text(
                  'Make a List',
                  style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold, color: primaryGreen,
                  ),
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
                // Build rows dynamically
                ListView.builder(
                  shrinkWrap: true, // Important within SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Disable ListView scrolling
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align top
                        children: [
                          // Food Item Field
                          Expanded(
                            flex: 3, // Give more space to food item
                            child: _buildStyledTextField(
                              controller: _items[index].foodNameController,
                              hintText: 'Food item',
                              validator: (value) { // Basic required validation
                                if (value == null || value.trim().isEmpty) {
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
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only numbers
                                 validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                     return 'Req.'; // Shorter error
                                  }
                                  return null;
                                }
                             ),
                          ),
                          // Remove Button (Optional) - Show only if not the first item
                          if (_items.length > 1)
                             Padding(
                               padding: const EdgeInsets.only(left: 4.0),
                               child: IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Colors.red[400]),
                                  onPressed: () => _removeItemRow(index),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(), // Remove extra padding
                               ),
                             )
                          else // Keep space consistent even if button isn't shown
                             const SizedBox(width: 48) // Approx width of IconButton
                        ],
                      ),
                    );
                  },
                ),
                // --- Add More Button ---
                TextButton.icon(
                  icon: const Icon(Icons.add_circle_outline, color: primaryGreen),
                  label: const Text(
                    'Add more food item',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _addItemRow,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                const SizedBox(height: 24),

                // --- Location Preference ---
                const Text(
                  'What is your preferred location to donate?',
                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                 Row( // Wrap text field in Row to add suffix icon easily
                  children: [
                    Expanded(
                      child: _buildStyledTextField(
                         controller: _locationController,
                         hintText: 'Enter the location',
                         // No validator needed unless location is required
                      ),
                    ),
                    // Adding the dropdown icon outside the TextField decoration
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- AI Button ---
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _findLocationAI,
                    icon: const Icon(Icons.search, color: Colors.white),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}