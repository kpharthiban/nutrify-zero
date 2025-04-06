import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import '../../widgets/custom_app_bar.dart'; // Assuming this exists

class AskForHelpScreen extends StatefulWidget {
  const AskForHelpScreen({super.key}); // Use const constructor

  @override
  _AskForHelpScreenState createState() => _AskForHelpScreenState();
}

class _AskForHelpScreenState extends State<AskForHelpScreen> {
  final _formKey = GlobalKey<FormState>();
  // Use TextEditingControllers
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  final _peopleController = TextEditingController();
  final _descriptionController = TextEditingController();
  // Removed String member variables and _contactMethod

  @override
  void dispose() {
    // Dispose controllers
    _locationController.dispose();
    _contactController.dispose();
    _peopleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Helper for styled TextFormFields (Adapted from previous examples)
  // Consider moving this to a shared widgets file
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    String? descriptionText,
    int maxLines = 1,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    required String? Function(String?) validator,
  }) {
     const Color lightGreyBackground = Color(0xFFF0F0F0);
     const Color labelColor = Colors.black54;

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
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                maxLines: maxLines,
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                ),
                validator: validator,
                 // Removed onSaved - using controllers directly
              ),
            ),
             if (suffixIcon != null)
               Padding(
                 padding: const EdgeInsets.only(left: 8.0),
                 child: Icon(suffixIcon, color: Colors.grey[600]),
               ),
          ],
        ),
      ],
    );
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save(); // Not needed when using controllers directly

      // Process form data from controllers
       final helpRequest = {
        'location': _locationController.text,
        'contactInfo': _contactController.text, // Single contact field
        'peopleCount': int.tryParse(_peopleController.text) ?? 0,
        'description': _descriptionController.text,
        'requestTime': DateTime.now().toIso8601String(), // Example timestamp
      };

      print('--- Submitting Help Request ---');
      print(helpRequest);
      print('-----------------------------');

      // TODO: Connect to backend to submit the request

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Help request submitted successfully!'),
            backgroundColor: Colors.green, // Keep success message green
         ),
      );
      Navigator.pop(context); // Return to previous screen
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Please fill in all required fields.')),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors
    const Color primaryRed = Color(0xFFE53935);

    return Scaffold(
      appBar: const CustomAppBar(), // Assuming default back button is fine
      body: SingleChildScrollView( // Use SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column( // Use Column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // --- Header ---
                const Text(
                  'Ask for Help',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryRed, // Red title
                  ),
                ),
                const Divider(height: 25, thickness: 1),

                // --- Location Field ---
                _buildStyledTextField(
                  controller: _locationController,
                  labelText: 'Location',
                  hintText: 'Enter the location',
                  suffixIcon: Icons.arrow_drop_down,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                 // --- Contact Details Field --- (Simplified)
                _buildStyledTextField(
                  controller: _contactController,
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


                // --- Number of People Field ---
                 _buildStyledTextField(
                  controller: _peopleController,
                  labelText: 'Number of people',
                  hintText: 'E.g. 1, 20, 30',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the number of people';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                // --- Description Field ---
                _buildStyledTextField(
                  controller: _descriptionController,
                  labelText: 'Description / More Details',
                  hintText: 'Enter more relevant details about your requests that might help volunteers to help more',
                  maxLines: 5,
                  validator: (value) {
                     if (value == null || value.trim().isEmpty) {
                       return 'Please enter a description of your needs';
                     }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),

                // --- Submit Button ---
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                     // Use sparkle/wand icon
                    icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20), // Or Icons.volunteer_activism
                    label: const Text('Ask for Help'),
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
                 const SizedBox(height: 20.0), // Bottom padding

              ],
            ),
          ),
        ),
      ),
    );
  }
}