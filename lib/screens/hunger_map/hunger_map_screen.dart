// File: lib/screens/hunger_map/hunger_map_screen.dart

import 'dart:async'; // For Future
import 'dart:typed_data'; // Required for Uint8List
import 'dart:ui' as ui; // Required for ui.Image, ui.PictureRecorder etc.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import Google Maps
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

// Import shared widgets and target screens (Adjust paths if necessary)
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_app_bar.dart';
import 'add_spot_screen.dart';
import 'spots_list_screen.dart';
import 'ask_for_help_screen.dart';
import 'my_request_screen.dart';

class HungerMapScreen extends StatefulWidget {
  const HungerMapScreen({super.key});

  @override
  State<HungerMapScreen> createState() => _HungerMapScreenState();
}

class _HungerMapScreenState extends State<HungerMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  // Initial map position (e.g., Cyberjaya coordinates)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(2.9213, 101.6559), // Centered on Cyberjaya
    zoom: 13.0, // Adjust initial zoom level as needed
  );

  // Variable to hold the single custom icon, loaded and resized
  BitmapDescriptor _hungerSpotIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    // Load the custom icon first, then fetch spots
    _loadAndResizeIcon().then((_) {
      _fetchHungerSpots();
    });
  }

  // --- Helper function to load an asset and resize it on a canvas ---
  Future<Uint8List> _getBytesFromAsset(String path, int desiredWidth) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: desiredWidth);
    ui.FrameInfo fi = await codec.getNextFrame();
    ui.Image image = fi.image;

    // Calculate height based on aspect ratio to maintain proportions
    int desiredHeight = (image.height * desiredWidth / image.width).round();

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw the image scaled to the desired dimensions
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0.0, 0.0, image.width.toDouble(), image.height.toDouble()), // Source rect
      Rect.fromLTRB(0.0, 0.0, desiredWidth.toDouble(), desiredHeight.toDouble()), // Destination rect (scaled)
      Paint(),
    );

    // Dispose the original ui.Image
    image.dispose();

    final img = await pictureRecorder.endRecording().toImage(desiredWidth, desiredHeight);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    // Dispose the canvas image
    img.dispose();


    if (byteData == null) {
       throw Exception("Unable to convert image to byte data for $path");
    }

    return byteData.buffer.asUint8List();
  }


  // --- Load the Single Custom Marker Icon using the Canvas method ---
  Future<void> _loadAndResizeIcon() async {
    // *** IMPORTANT: Define the desired width IN PIXELS for the marker ***
    // Experiment with this value (e.g., 100, 120, 150) to get desired size
    const int markerWidthPixels = 84; // Adjust this for marker size

    // *** IMPORTANT: Verify this asset path matches your project structure ***
    // *** and that 'assets/markers/' is declared in pubspec.yaml ***
    const String iconAssetPath = 'assets/markers/hunger_pin.png'; // <<< YOUR ICON PATH

    try {
      final Uint8List imageData = await _getBytesFromAsset(
          iconAssetPath,
          markerWidthPixels
      );
      _hungerSpotIcon = BitmapDescriptor.fromBytes(imageData);
      print("Custom $iconAssetPath loaded and resized to width: $markerWidthPixels");

    } catch (e) {
        print("Error loading and resizing custom icon '$iconAssetPath': $e");
        _hungerSpotIcon = BitmapDescriptor.defaultMarker; // Fallback to default marker
    }

    // Update state only if the widget is still mounted after async operations
    if (mounted) {
        setState(() {});
    }
  } // --- End _loadAndResizeIcon ---


  // --- Function to fetch data from Firestore ---
  Future<void> _fetchHungerSpots() async {
     if (!mounted) return; // Check if widget is still mounted
     setState(() { _isLoading = true; }); // Show loading indicator

     try {
       // Query the 'hungerSpots' collection in Firestore
       final snapshot = await FirebaseFirestore.instance.collection('hungerSpots').get();
       final List<Marker> fetchedMarkers = []; // Temporary list for new markers

       print("Firestore snapshot received with ${snapshot.docs.length} documents.");

       for (var doc in snapshot.docs) {
         final data = doc.data();

         // --- Data Extraction and Validation ---
         final GeoPoint? locationData = data['location'] as GeoPoint?; // Extract GeoPoint
         final String name = data['name'] as String? ?? 'Unknown Spot';
         final String description = data['description'] as String? ?? 'No description';
         // Optional: Extract spotType if needed for InfoWindow or future logic
         // final String spotType = data['spotType'] as String? ?? 'default';

         // Basic validation: Skip if location is missing
         if (locationData == null) {
           print("Skipping spot ${doc.id}: Missing or invalid 'location' GeoPoint field.");
           continue; // Go to the next document
         }

         // --- Marker Creation ---
         fetchedMarkers.add(
           Marker(
             markerId: MarkerId(doc.id), // Unique ID for the marker
             position: LatLng(locationData.latitude, locationData.longitude), // Convert GeoPoint to LatLng
             icon: _hungerSpotIcon, // Use the single pre-loaded & resized icon
             infoWindow: InfoWindow( // Info shown when marker is tapped
               title: name,
               snippet: description, // Keep snippet concise if possible
             ),
             // TODO: Add onTap if you want to navigate to details when marker is tapped
             // onTap: () {
             //   print('Marker tapped: ${doc.id}');
             //   // Example: Navigator.push(context, MaterialPageRoute(builder: (_) => SpotDetailScreen(spotId: doc.id)));
             // },
           ),
         );
       } // End loop through documents

       // --- Update State ---
       if (mounted) {
         setState(() {
           _markers.clear(); // Remove old markers
           _markers.addAll(fetchedMarkers); // Add the newly created markers
           _isLoading = false; // Hide loading indicator
         });
         print("Map updated with ${_markers.length} markers.");
       }
     } catch (e) {
       print("Error fetching hunger spots from Firestore: $e");
       if (mounted) {
         setState(() { _isLoading = false; }); // Hide loading on error too
         // Show error message to the user
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading map spots: $e')),
         );
       }
     }
  } // --- End _fetchHungerSpots ---


  // --- Helper for the bottom Red Action Buttons ---
  Widget _buildRedActionBox({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Widget targetScreen,
  }) {
    const Color primaryRed = Color(0xFFE53935);
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: primaryRed,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: Colors.white),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // --- End _buildRedActionBox ---


  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935);
    const Color subtitleColor = Colors.black54;

    return Scaffold(
      // Adjust showBackButton based on your app's navigation flow
      appBar: const CustomAppBar(showBackButton: true),
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
                  'HungerMap',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryRed,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'See local needs & request food support.',
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
                  markers: _markers, // Display the loaded markers
                  onMapCreated: (GoogleMapController controller) {
                    if (!mounted) return;
                    // Assign controller only once
                    if (_mapController == null) {
                       setState(() { _mapController = controller; });
                       print("Google Map Controller assigned.");
                    }
                  },
                   myLocationEnabled: true, // Shows blue dot if permission granted
                   myLocationButtonEnabled: true, // Requires location permission
                   // TODO: Request location permission (e.g., using 'location' package) for these buttons to work fully
                   padding: const EdgeInsets.only(bottom: 50.0, top: 10.0), // Avoid overlap
                ),
                // --- End Google Map Widget ---

                // Loading Indicator Overlay
                if (_isLoading)
                  Container(
                    color: Colors.white.withOpacity(0.7), // Optional: dim background
                    child: const Center(child: CircularProgressIndicator()),
                  ),

                // Removed static overlay text as markers now show data
              ],
            ),
          ), // End of Expanded Map Area

          // --- Action Button Bar ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRedActionBox(
                  context: context,
                  icon: Icons.add_location_alt_outlined,
                  label: 'Add\nHungerSpots',
                  targetScreen: const AddSpotScreen(),
                ),
                _buildRedActionBox(
                  context: context,
                  icon: Icons.auto_awesome,
                  label: 'Ask for\nHelp',
                  targetScreen: const AskForHelpScreen(),
                ),
                _buildRedActionBox(
                  context: context,
                  icon: Icons.format_list_bulleted,
                  label: 'List of\nHungerSpots',
                  targetScreen: SpotsListScreen(),
                ),
                _buildRedActionBox(
                  context: context,
                  icon: Icons.receipt_long_outlined,
                  label: 'My\nRequest',
                  targetScreen: const MyRequestScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
      // Make sure index matches the HungerMap tab
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}