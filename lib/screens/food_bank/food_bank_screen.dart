import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Assuming these widgets exist at these paths, adjust if necessary
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_app_bar.dart';
import 'add_food_bank_screen.dart';
import 'food_banks_list_screen.dart';

// Convert to StatefulWidget
class FoodBankScreen extends StatefulWidget {
  const FoodBankScreen({super.key});

  @override
  State<FoodBankScreen> createState() => _FoodBankScreenState();
}

class _FoodBankScreenState extends State<FoodBankScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  // Initial map position (e.g., Cyberjaya or a more relevant default)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(2.9213, 101.6559), // Keep Cyberjaya or change
    zoom: 13.0,
  );

  // Icon variable
  BitmapDescriptor _foodBankIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _loadAndResizeIcon().then((_) {
      _fetchFoodBanks(); // Fetch food bank data
    });
  }

   // --- Helper function to load and resize asset (same as before) ---
  Future<Uint8List> _getBytesFromAsset(String path, int desiredWidth) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: desiredWidth);
    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image image = fi.image;
    int desiredHeight = (image.height * desiredWidth / image.width).round();
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    canvas.drawImageRect(image, Rect.fromLTRB(0.0, 0.0, image.width.toDouble(), image.height.toDouble()), Rect.fromLTRB(0.0, 0.0, desiredWidth.toDouble(), desiredHeight.toDouble()), Paint());
    image.dispose(); // Dispose original image
    final img = await pictureRecorder.endRecording().toImage(desiredWidth, desiredHeight);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    img.dispose(); // Dispose canvas image
    if (byteData == null) throw Exception("Unable to convert image to byte data for $path");
    return byteData.buffer.asUint8List();
  }

  // --- Load the Food Bank Custom Marker Icon ---
  Future<void> _loadAndResizeIcon() async {
    // *** Define desired marker size in pixels ***
    const int markerWidthPixels = 84; // Adjust if needed

    // *** Verify asset path ***
    const String iconAssetPath = 'assets/markers/food_bank_pin.png'; // <<< YOUR FOOD BANK ICON PATH

    try {
      final Uint8List imageData = await _getBytesFromAsset(iconAssetPath, markerWidthPixels);
      _foodBankIcon = BitmapDescriptor.fromBytes(imageData);
      print("Custom $iconAssetPath loaded and resized to width: $markerWidthPixels");
    } catch (e) {
      print("Error loading and resizing custom icon '$iconAssetPath': $e");
      _foodBankIcon = BitmapDescriptor.defaultMarker; // Fallback
    }
    if (mounted) {
      setState(() {});
    }
  } // --- End _loadAndResizeIcon ---

  // --- Function to fetch Food Bank data from Firestore ---
  Future<void> _fetchFoodBanks() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });

    try {
      // *** Query 'foodBanks' collection ***
      final snapshot = await FirebaseFirestore.instance.collection('foodBanks').get();
      final List<Marker> fetchedMarkers = [];

      print("Firestore snapshot received with ${snapshot.docs.length} food bank documents.");

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final GeoPoint? locationData = data['location'] as GeoPoint?;
        final String name = data['name'] as String? ?? 'Unknown Food Bank';
        // Get description or other fields needed for InfoWindow
        final String description = data['description'] as String? ?? 'No details available';

        if (locationData == null) {
           print("Skipping food bank ${doc.id}: Missing or invalid 'location' GeoPoint field.");
          continue;
        }

        // Create marker using the loaded food bank icon
        fetchedMarkers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(locationData.latitude, locationData.longitude),
            icon: _foodBankIcon, // Use the specific food bank icon
            infoWindow: InfoWindow(
              title: name,
              snippet: description, // Display description on tap
            ),
            // TODO: Add onTap if needed
          ),
        );
      } // End loop

      if (mounted) {
        setState(() {
          _markers.clear();
          _markers.addAll(fetchedMarkers);
          _isLoading = false;
        });
        print("Map updated with ${_markers.length} food bank markers.");
      }
    } catch (e) {
      print("Error fetching food banks from Firestore: $e");
      if (mounted) {
        setState(() { _isLoading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error loading food bank spots: $e')),
        );
      }
    }
  } // --- End _fetchFoodBanks ---


  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      appBar: const CustomAppBar(showBackButton: true), // Adjust as needed
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                 Text(
                  'Food Bank',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen, // Green title
                  ),
                ),
                 SizedBox(height: 4),
                 Text(
                  'Find your local food bank and support them.',
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
              ],
            ),
          ),

          // --- Map Area ---
          Expanded(
            child: Stack(
              children: [
                 // --- Google Map Widget ---
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialPosition,
                  markers: _markers, // Use the state variable for markers
                  onMapCreated: (GoogleMapController controller) {
                     if (!mounted) return;
                     if (_mapController == null) {
                        setState(() { _mapController = controller; });
                        print("Map Created!");
                     }
                  },
                   myLocationEnabled: true,
                   myLocationButtonEnabled: true,
                   padding: const EdgeInsets.only(bottom: 50.0, top: 10.0),
                ),
                 // --- End Google Map Widget ---

                // Loading Indicator
                if (_isLoading)
                  Container(
                     color: Colors.white.withOpacity(0.7),
                     child: const Center(child: CircularProgressIndicator()),
                  ),

                 // Optional: Overlay Text (Can be removed)
                 Align(
                   alignment: Alignment.bottomCenter,
                   child: Container(
                     margin: const EdgeInsets.only(bottom: 15.0),
                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                     decoration: BoxDecoration(
                       color: Colors.black.withOpacity(0.6),
                       borderRadius: BorderRadius.circular(20.0),
                     ),
                     child: const Text(
                       'Food Bank locations loaded from database', // Updated text
                       style: TextStyle(color: Colors.white, fontSize: 12),
                     ),
                   ),
                 ),
              ],
            ),
          ), // End of Expanded Map Area

          // --- Action Buttons Row (Using original styling) ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                // Add Food Bank Button (Solid Green)
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.inventory_2_outlined, color: Colors.white), // Placeholder Icon
                    label: const Text('Add Food Bank'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddFoodBankScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons

                // List of Food Banks Button (Outlined Green)
                Expanded(
                  child: OutlinedButton.icon(
                     icon: const Icon(Icons.format_list_bulleted, color: primaryGreen),
                     label: const Text('List of Food Banks'),
                     onPressed: () => Navigator.push(
                        context,
                        // Navigate to the Food Bank List screen
                        MaterialPageRoute(builder: (_) => FoodBanksListScreen()),
                     ),
                     style: OutlinedButton.styleFrom(
                       foregroundColor: primaryGreen,
                       side: const BorderSide(color: primaryGreen, width: 1.5),
                       padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12.0),
                       ),
                       textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                     ),
                  ),
                ),
              ],
            ),
          ), // --- End Action Buttons Row ---
        ],
      ),
      // Use shared bottom nav bar, set correct index for Food Bank
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}