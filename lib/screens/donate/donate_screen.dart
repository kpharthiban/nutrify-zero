// File: lib/screens/donate/donate_screen.dart (Adjust path if necessary)

import 'dart:async';
import 'dart:convert'; // For jsonDecode
import 'dart:typed_data'; // For Uint8List

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'package:google_generative_ai/google_generative_ai.dart'; // Import Gemini package

// Assuming these widgets exist at these paths, adjust if necessary
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_app_bar.dart';

// Import the target screens for navigation
import 'make_list_screen.dart'; // Needs to accept initialItems
import '../hunger_map/hunger_map_screen.dart';
import '../food_bank/food_bank_screen.dart';
import '../discover/discover_screen.dart'; // Assuming DiscoverScreen exists

// Convert DonateScreen to StatefulWidget to handle loading state
class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  // State variable for loading indicator during image processing/analysis
  bool _isProcessingImage = false;

  // --- Helper for the top Green Action Boxes (Scan, Make a List) ---
  Widget _buildGreenActionBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    const Color primaryGreen = Color(0xFF4CAF50);

    // Disable GestureDetector if processing
    return GestureDetector(
      onTap: _isProcessingImage ? null : onPressed, // Disable tap while processing
      child: Opacity( // Dim the box while processing
         opacity: _isProcessingImage ? 0.5 : 1.0,
         child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // --- End _buildGreenActionBox ---

  // --- Helper for the bottom Colored Navigation Cards ---
  Widget _buildColorNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Widget targetScreen,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push( context, MaterialPageRoute(builder: (_) => targetScreen) ),
      child: Container(
         margin: const EdgeInsets.only(bottom: 12.0),
         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
         decoration: BoxDecoration(
           color: backgroundColor,
           borderRadius: BorderRadius.circular(12.0),
           boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))]),
         child: Row(
           children: [
             Icon(icon, size: 36, color: Colors.white),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text( title, style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                   const SizedBox(height: 4),
                   Text( subtitle, style: const TextStyle( color: Colors.white, fontSize: 14))],
               ),
             ),
             const Icon(Icons.arrow_forward, color: Colors.white),
           ],
         ),
      ),
    );
  } // --- End _buildColorNavigationCard ---

  // --- Gemini Image Analysis Function ---
  Future<List<Map<String, String>>?> _analyzeImageWithGemini(Uint8List imageBytes) async {
    // Retrieve API key securely from environment
    final String? apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      print("CRITICAL ERROR: GEMINI_API_KEY not found or empty in .env file.");
       if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('API Key configuration error! Cannot analyze.'), backgroundColor: Colors.red)
          );
       }
      return null; // Indicate configuration error
    }

    // Initialize the Generative Model
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    // Define the prompt for the Gemini API
    final prompt = TextPart(
      "Analyze this image precisely. Identify only distinct food items visible. Estimate the quantity for each item (examples: '3', '1 loaf', 'approx 500g', '1 bunch'). Format the result ONLY as a valid JSON list of objects, where each object has a 'food' key (string) and a 'quantity' key (string). Example: [{'food': 'Apple', 'quantity': '3'}, {'food': 'Banana', 'quantity': '1 bunch'}]. If no food items are clearly identifiable, return an empty JSON list []."
    );
    // Prepare the image data
    final imagePart = DataPart('image/jpeg', imageBytes); // Assuming JPEG from camera

    print("Sending image to Gemini for analysis...");
    try {
      // Call the Gemini API
      final response = await model.generateContent([Content.multi([prompt, imagePart])]);
      final String? responseText = response.text;
      print("Gemini Raw Response Text: ${responseText ?? 'No text response'}");

      // Process the response
      if (responseText != null) {
         try {
            // Clean potential markdown formatting
            String jsonString = responseText.replaceAll("```json", "").replaceAll("```", "").trim();
            if (jsonString.isEmpty) {
              print("Gemini returned empty string, parsing as empty list.");
              return []; // Return empty list
            }
            // Decode the JSON string
            final List<dynamic> decodedList = jsonDecode(jsonString);
            // Convert to the expected List<Map<String, String>> format safely
            final List<Map<String, String>> itemsList = decodedList
                .map((item) => (item is Map && item.containsKey('food') && item.containsKey('quantity')) ? Map<String, String>.from(item) : null)
                .whereType<Map<String, String>>() // Filter out invalid items
                .toList();
            print("Parsed items: $itemsList");
            return itemsList; // Return the list of detected items
         } catch (e) {
            print("Error parsing Gemini JSON response: $e");
            print("Received text that failed parsing: $responseText");
            return null; // Indicate parsing failure
         }
      } else {
        print("Gemini response text was null.");
        return []; // Treat null response as empty list
      }
    } catch (e) {
      print("Error calling Gemini API: $e");
      // Propagate the error to be caught by the calling function
      throw Exception("Failed to analyze image with Gemini: $e");
    }
  } // --- End _analyzeImageWithGemini ---


  // --- Function to handle picking image AND triggering analysis ---
  Future<void> _scanWithCamera(BuildContext context) async {
    if (_isProcessingImage) return; // Prevent multiple calls if already busy

    final ImagePicker picker = ImagePicker();
    List<Map<String, String>>? detectedItems; // Result variable

    // --- Start Loading State ---
    if (!mounted) return;
    setState(() { _isProcessingImage = true; });

    try {
      // Launch the native camera
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        // imageQuality: 80, // Optional
        // maxWidth: 1080, // Optional
      );

      if (!mounted) return; // Check mount status after camera await

      if (pickedFile != null) {
        print('Image picked from camera: ${pickedFile.path}');

        // --- Read image bytes and call Gemini Analysis ---
        final imageBytes = await pickedFile.readAsBytes();
        print('Read ${imageBytes.lengthInBytes} bytes. Analyzing...');
        detectedItems = await _analyzeImageWithGemini(imageBytes); // Call the analysis function
        print('Analysis function returned: $detectedItems');
        // --- Analysis result stored in detectedItems ---

      } else {
        // User cancelled the camera
        print('User cancelled camera.');
        // No items detected if cancelled
        detectedItems = []; // Set to empty list if cancelled
      }
    } catch (e) {
       print('Error during camera or analysis processing: $e');
       if (mounted) {
           // Show specific error message based on caught exception
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('An error occurred: $e'), backgroundColor: Colors.red),
           );
       }
        // Set items to null on error
        detectedItems = null;
    } finally {
       // --- Stop Loading State ---
       // Ensure loading indicator is hidden regardless of outcome
       if (mounted) {
         setState(() { _isProcessingImage = false; });
       }
    }

     // --- Handle Navigation AFTER processing completes ---
     if (!mounted) return; // Final check before navigation/snackbar

     if (detectedItems != null && detectedItems.isNotEmpty) {
        // Navigate to MakeListScreen with the detected items
        print("Detected Items: $detectedItems. Navigating to MakeListScreen...");
        Navigator.push( // Use push, allows user to go back from list if needed
           context,
           MaterialPageRoute(
             // Ensure MakeListScreen is updated to accept initialItems
             builder: (_) => MakeListScreen(initialItems: detectedItems),
           ),
        );
     } else if (detectedItems != null && detectedItems.isEmpty) {
          // Handle case where camera was cancelled or AI found nothing
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('No food items were detected.')),
           );
     } else { // detectedItems is null (implies an error happened during analysis/parsing)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not analyze image. Check API Key or connection.'), backgroundColor: Colors.orange),
          );
     }

  } // --- End _scanWithCamera ---


  @override
  Widget build(BuildContext context) {
    // Define colors
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color primaryRed = Color(0xFFE53935);
    const Color textColor = Colors.black87;
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack( // Use Stack to overlay loading indicator
        children: [
          // Main scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Section 1: Header ---
                const Text('Donate', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen)),
                const SizedBox(height: 4),
                const Text('food for those in need.', style: TextStyle(fontSize: 16, color: textColor)),
                const SizedBox(height: 12),
                Text('Let AI help you find where to donate!', style: TextStyle(fontSize: 14, color: subtitleColor)),
                const SizedBox(height: 24),

                // --- Section 2: Action Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: _buildGreenActionBox(
                        icon: Icons.camera_alt_outlined,
                        title: 'Scan',
                        subtitle: 'food or leftover items available to donate',
                        onPressed: () => _scanWithCamera(context), // Calls the updated function
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildGreenActionBox(
                        icon: Icons.list_alt,
                        title: 'Make a List',
                        subtitle: 'of food or leftover items available to donate',
                        onPressed: () => Navigator.push( // Navigate directly
                          context,
                          MaterialPageRoute(builder: (_) => const MakeListScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- Section 3: Navigation Cards ---
                Text('Head over to these sections to explore where you can donate!', style: TextStyle(fontSize: 15, color: subtitleColor)),
                const SizedBox(height: 16),
                _buildColorNavigationCard(
                  context: context,
                  icon: Icons.map_outlined,
                  title: 'HungerMap',
                  subtitle: 'Find those in need to donate food',
                  backgroundColor: primaryRed,
                  targetScreen: const HungerMapScreen(),
                ),
                const SizedBox(height: 12),
                _buildColorNavigationCard(
                   context: context,
                   icon: Icons.store_outlined,
                   title: 'Food Bank',
                   subtitle: 'Search food banks to donate food',
                   backgroundColor: primaryGreen,
                   targetScreen: const FoodBankScreen(),
                ),
                 const SizedBox(height: 20), // Bottom padding
              ],
            ),
          ),

           // --- Loading Indicator Overlay ---
           if (_isProcessingImage)
             Positioned.fill( // Make overlay cover the whole screen
               child: Container(
                 color: Colors.black.withOpacity(0.6),
                 child: const Center(
                    child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                             "Analyzing Image...",
                             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, decoration: TextDecoration.none),
                          )
                       ],
                    )
                 ),
               ),
             ),
        ],
      ),
       // Assuming CustomBottomNavBar exists
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
} // --- End _DonateScreenState ---


// --- Reused Helper ---
// Make sure this helper definition is included or imported
Widget _buildColorNavigationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Widget targetScreen,
  }) {
     // ... Implementation from previous step ...
    return GestureDetector( onTap: () => Navigator.push(context,MaterialPageRoute(builder: (_) => targetScreen)), child: Container( margin: const EdgeInsets.only(bottom: 12.0), padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), decoration: BoxDecoration( color: backgroundColor, borderRadius: BorderRadius.circular(12.0), boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))]), child: Row( children: [ Icon(icon, size: 36, color: Colors.white), const SizedBox(width: 16), Expanded( child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text( title, style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, )), const SizedBox(height: 4), Text( subtitle, style: const TextStyle( color: Colors.white, fontSize: 14, ))])), const Icon(Icons.arrow_forward, color: Colors.white)])));
  }