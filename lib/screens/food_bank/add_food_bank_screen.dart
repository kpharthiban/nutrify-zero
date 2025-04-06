import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart'; // Assuming this exists

class AddFoodBankScreen extends StatefulWidget {
  const AddFoodBankScreen({super.key});

  @override
  State<AddFoodBankScreen> createState() => _AddFoodBankScreenState();
}

class _AddFoodBankScreenState extends State<AddFoodBankScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers based on the design
  final _locationController = TextEditingController();
  final _contactDetailsController = TextEditingController();
  final _foodBankDetailsController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _contactDetailsController.dispose();
    _foodBankDetailsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Gather data from the controllers
      final String location = _locationController.text;
      final String contactDetails = _contactDetailsController.text;
      final String foodBankDetails = _foodBankDetailsController.text;

      print('--- Submitting Food Bank ---');
      print('Location: $location');
      print('Contact Details: $contactDetails');
      print('Food Bank Details: $foodBankDetails');
      print('----------------------------');

      // TODO: Implement actual backend/API call here

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food Bank submitted successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
    }
  }

  // Helper to build styled TextFormFields consistently
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    String? descriptionText,
    int maxLines = 1,
    IconData? suffixIcon, // For dropdown arrow
    required String? Function(String?) validator,
  }) {
    const Color lightGreyBackground = Color(0xFFF0F0F0); // Background color for fields
    const Color labelColor = Colors.black54; // Color for labels

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText + ':',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: labelColor,
          ),
        ),
        if (descriptionText != null) ...[
          const SizedBox(height: 4.0),
          Text(
            descriptionText,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            filled: true,
            fillColor: lightGreyBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
              borderSide: BorderSide.none, // No visible border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              // Optionally add a subtle border on focus
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey[600]) : null,
          ),
          validator: validator,
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    // Define colors from the design
    const Color primaryGreen = Color(0xFF4CAF50); // Example green color

    return Scaffold(
      appBar: CustomAppBar(), // Use your app bar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- Screen Title ---
                const Text(
                  'Add Food Bank',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen, // Green title
                  ),
                ),
                const Divider(height: 25, thickness: 1), // Divider below title


                // --- Location Field ---
                _buildTextField(
                  controller: _locationController,
                  labelText: 'Location',
                  hintText: 'Enter the location',
                  suffixIcon: Icons.arrow_drop_down, // Dropdown arrow
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                // --- Contact Details Field ---
                _buildTextField(
                  controller: _contactDetailsController,
                  labelText: 'Contact Details',
                  descriptionText: 'Please enter any of your contact details (to be contacted by the donors).',
                  hintText: 'Contact Number / Email / Usernames - [Contact Method?]',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter contact details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                // --- Details about the Food Bank Field ---
                _buildTextField(
                  controller: _foodBankDetailsController,
                  labelText: 'Details about the Food Bank',
                  hintText: 'Enter more relevant details about the Food Bank that might help volunteers to contribute more to your foodbank',
                  maxLines: 5, // Allow multiple lines
                   validator: (value) {
                    // Make details optional or required based on your needs
                    // if (value == null || value.trim().isEmpty) {
                    //   return 'Please enter some details';
                    // }
                    return null; // Currently optional
                  },
                ),
                const SizedBox(height: 30.0), // Space before button

                // --- Submit Button ---
                Center( // Center the button horizontally
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.add, color: Colors.white), // Plus icon
                    label: const Text('Add Food Bank'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen, // Green background
                      foregroundColor: Colors.white, // White text/icon
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Rounded button
                      ),
                    ),
                  ),
                ),
                 const SizedBox(height: 20.0), // Padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}