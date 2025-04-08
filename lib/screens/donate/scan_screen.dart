import 'dart:async'; // For Future
import 'dart:convert'; // For jsonDecode
import 'dart:typed_data'; // For Uint8List

import 'package:camera/camera.dart'; // Import camera package
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle and image bytes
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'package:google_generative_ai/google_generative_ai.dart'; // Import Gemini package

// Import shared widgets and target screens (Adjust paths if necessary)
import '../../widgets/custom_app_bar.dart';
import '../donate/make_list_screen.dart'; // Import MakeListScreen

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isAnalyzing = false; // State for loading indicator during analysis

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera(); // Start camera initialization
  }

  // --- Initialize Camera ---
  // (Includes error handling and finding back camera)
  Future<void> _initializeCamera() async {
    print("Initializing camera...");
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        print('Error: No cameras found');
        if (mounted) setState(() {}); // Update UI to show potential error
        return;
      }

      // Find the first back-facing camera
      final firstCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras!.first, // Fallback to any camera if no back camera
      );

      // Dispose existing controller if any before creating new one
      if (_controller != null) {
         await _controller!.dispose();
         _controller = null; // Ensure old controller is nullified
         print("Previous camera controller disposed.");
      }


      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high, // Use high resolution for better analysis
        enableAudio: false,   // No audio needed for image scanning
        imageFormatGroup: ImageFormatGroup.jpeg, // Or nv21 depending on analysis needs
      );

      // Initialize the controller and store the Future
      _initializeControllerFuture = _controller!.initialize().then((_) {
        if (!mounted) return;
        print("Camera initialized successfully.");
        setState(() {}); // Rebuild UI with preview
      }).catchError((Object e) {
        if (mounted) setState(() {}); // Update UI to show error
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('Error: Camera access denied.');
              // TODO: Show user a message asking for permission
              break;
            case 'CameraAccessDeniedWithoutPrompt':
               // iOS specific - permission not determined or previously denied
               print('Error: Camera permission previously denied or not determined.');
               // TODO: Guide user to settings
               break;
             case 'CameraAccessRestricted':
                // iOS specific - parental controls etc.
                print('Error: Camera access restricted.');
                break;
            default:
              print('Error initializing camera: ${e.code} - ${e.description}');
              break;
          }
        } else {
          print('Unknown error initializing camera: $e');
        }
      });
    } catch (e) {
      print('Error fetching available cameras: $e');
      if (mounted) setState(() {}); // Update UI
    }
     // Ensure rebuild happens if already mounted when future completes/errors
     if (mounted) {
       setState(() {});
     }
  }

  // --- Handle App Lifecycle Changes ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      print("Camera disposed due to inactivity.");
      cameraController.dispose(); // Dispose on inactive
    } else if (state == AppLifecycleState.resumed) {
      print("Resuming camera...");
      _initializeCamera(); // Re-initialize on resume
    }
  }

  // --- Dispose Controller ---
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose(); // Dispose controller on screen disposal
    print("ScanScreen disposed, camera controller disposed.");
    super.dispose();
  }

  // --- Gemini Image Analysis Function ---
  Future<List<Map<String, String>>?> _analyzeImageWithGemini(Uint8List imageBytes) async {
    final String? apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      print("CRITICAL ERROR: GEMINI_API_KEY not found in .env file.");
       if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('API Key Error! Cannot analyze.'), backgroundColor: Colors.red)
          );
       }
      return null;
    }
    print('--- Retrieved API Key: $apiKey ---');
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    final prompt = TextPart(
      "Analyze this image precisely. Identify only distinct food items visible. Estimate the quantity for each item (examples: '3', '1 loaf', 'approx 500g', '1 bunch'). Format the result ONLY as a valid JSON list of objects, where each object has a 'food' key (string) and a 'quantity' key (string). Example: [{'food': 'Apple', 'quantity': '3'}, {'food': 'Banana', 'quantity': '1 bunch'}]. If no food items are clearly identifiable, return an empty JSON list []."
    );
    final imagePart = DataPart('image/jpeg', imageBytes);

    print("Sending image to Gemini for analysis...");
    try {
      final response = await model.generateContent([Content.multi([prompt, imagePart])]);
      final String? responseText = response.text;
      print("Gemini Raw Response Text: ${responseText ?? 'No text response'}");

      if (responseText != null) {
         try {
            String jsonString = responseText.replaceAll("```json", "").replaceAll("```", "").trim();
            if (jsonString.isEmpty) return [];
            final List<dynamic> decodedList = jsonDecode(jsonString);
            final List<Map<String, String>> itemsList = decodedList
                .map((item) => (item is Map && item.containsKey('food') && item.containsKey('quantity')) ? Map<String, String>.from(item) : null)
                .whereType<Map<String, String>>()
                .toList();
            return itemsList;
         } catch (e) {
            print("Error parsing Gemini JSON response: $e");
            print("Received text that failed parsing: $responseText");
            return null;
         }
      } else {
        return [];
      }
    } catch (e) {
      print("Error calling Gemini API: $e");
      throw Exception("Failed to analyze image with Gemini: $e");
    }
  } // --- End _analyzeImageWithGemini ---

  // --- Updated Function to Take Picture and Trigger Analysis ---
  Future<void> _takePicture() async {
    print("--- _takePicture: START ---"); // START

    final initFuture = _initializeControllerFuture;
    if (_controller == null || initFuture == null) {
       print("--- _takePicture: ERROR - Controller or initFuture null ---");
       return;
    }

    try {
      print("--- _takePicture: Waiting for camera initialization... ---");
      await initFuture; // Wait for initialization if needed
      print("--- _takePicture: Camera initialization complete. ---");

      if (!_controller!.value.isInitialized){
          print("--- _takePicture: ERROR - Controller not initialized after wait ---");
          if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera initialization failed.')));
          return;
      }
      if (_controller!.value.isTakingPicture) {
        print("--- _takePicture: Already taking picture, exiting. ---");
        return;
      }
       if (_isAnalyzing) {
        print("--- _takePicture: Already analyzing, exiting. ---");
        return;
      }

      print("--- _takePicture: Attempting to take picture... ---");
      final XFile imageFile = await _controller!.takePicture(); // TAKE PICTURE
      print('--- _takePicture: Picture taken successfully! Path: ${imageFile.path} ---');

      // --- Start Analysis Section ---
      if (!mounted) { print("--- _takePicture: NOT MOUNTED before analysis section ---"); return; }
      print('--- _takePicture: Setting _isAnalyzing = true ---');
      setState(() { _isAnalyzing = true; });

      print('--- _takePicture: Reading image bytes... ---');
      final imageBytes = await imageFile.readAsBytes(); // READ BYTES
      print('--- _takePicture: Image bytes read (${imageBytes.lengthInBytes} bytes). ---');

      print('--- _takePicture: >>> CALLING _analyzeImageWithGemini NOW >>> ---');
      final List<Map<String, String>>? items = await _analyzeImageWithGemini(imageBytes); // <<< CALL GEMINI FUNC
      print('--- _takePicture: <<< RETURNED FROM _analyzeImageWithGemini. Result: $items >>> ---');


      if (!mounted) { print("--- _takePicture: NOT MOUNTED after analysis section ---"); return; }
      print('--- _takePicture: Setting _isAnalyzing = false ---');
      setState(() { _isAnalyzing = false; });
      // --- End Analysis Section ---

      // --- Handle Analysis Result ---
      if (items != null && items.isNotEmpty) {
        print("--- _takePicture: Items found (${items.length}). Navigating to MakeListScreen... ---");
        Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (_) => MakeListScreen(initialItems: items)),
        );
      } else {
        print("--- _takePicture: Items list is null or empty. Showing SnackBar. ---");
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Could not detect food items or analysis failed.')),
        );
      }
      print("--- _takePicture: FINISHED try block successfully ---");

    } on CameraException catch (e) {
      print('--- _takePicture: CAUGHT CameraException: ${e.code}, ${e.description} ---');
       if (mounted) {
         setState(() { _isAnalyzing = false; }); // Ensure loading stops on error
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Camera error: ${e.description}')),
         );
       }
    } catch (e, stackTrace) { // Catch ALL other errors
      print('--- _takePicture: CAUGHT GENERIC Error: $e ---');
      print('--- _takePicture: Error StackTrace: $stackTrace ---'); // Print stacktrace
      if (mounted) {
        setState(() { _isAnalyzing = false; }); // Ensure loading stops on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An processing error occurred: $e')),
        );
      }
    } finally {
        print("--- _takePicture: FINALLY block reached ---");
        // Optional: Ensure loading state is reset if something unexpected happened
        if (mounted && _isAnalyzing) {
           setState(() { _isAnalyzing = false; });
        }
    }
  } // --- End _takePicture ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure CustomAppBar exists and is imported
      appBar: const CustomAppBar(), // Added title
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          final bool isCameraReady = snapshot.connectionState == ConnectionState.done &&
                                     _controller != null &&
                                     _controller!.value.isInitialized;

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // --- Camera Preview ---
              if (isCameraReady)
                Center( // Center the preview to handle different aspect ratios
                  child: AspectRatio(
                    // Use aspect ratio from controller to prevent distortion
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                )
              else if (snapshot.hasError || snapshot.connectionState == ConnectionState.done) // Show error if done but not ready, or hasError
                // --- Error State ---
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Error initializing camera.\nPlease ensure permissions are granted in device settings.',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                )
              else
                 // --- Loading State ---
                 const Center(child: CircularProgressIndicator()), // Show loading indicator

               // --- Bottom Overlays (Hint + Button) ---
               // Only show if camera is ready
               if (isCameraReady)
                 Positioned(
                   bottom: 0,
                   left: 0,
                   right: 0,
                   child: Container(
                     padding: const EdgeInsets.only(bottom: 30.0, top: 20.0),
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         // Hint Text
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                           decoration: BoxDecoration(
                             color: Colors.black.withOpacity(0.5),
                             borderRadius: BorderRadius.circular(20.0),
                           ),
                           child: const Text(
                             'Take picture to analyze food',
                             style: TextStyle(color: Colors.white, fontSize: 14),
                           ),
                         ),
                         const SizedBox(height: 20),
                         // Capture Button
                         InkWell(
                           onTap: _isAnalyzing ? null : _takePicture, // Disable tap during analysis
                           customBorder: const CircleBorder(),
                           child: Opacity(
                             opacity: _isAnalyzing ? 0.5 : 1.0, // Dim button when analyzing
                             child: Container( // Outer circle (border)
                               padding: const EdgeInsets.all(4.0),
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 border: Border.all(color: Colors.white, width: 3),
                               ),
                               child: Container( // Inner circle (fill)
                                 width: 65, height: 65,
                                  decoration: const BoxDecoration(
                                   color: Colors.white,
                                   shape: BoxShape.circle,
                                  ),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),

              // --- Loading Overlay for Analysis ---
              if (_isAnalyzing)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text("Analyzing Image...", style: TextStyle(color: Colors.white, fontSize: 16)),
                       ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
} // --- End of _ScanScreenState ---


// --- Reminder: Update MakeListScreen ---
/*
 In make_list_screen.dart:

 1. Add an optional parameter to the constructor:
    final List<Map<String, String>>? initialItems;
    const MakeListScreen({super.key, this.initialItems});

 2. Update _MakeListScreenState's initState() to use widget.initialItems
    to populate the initial _items list if initialItems is not null/empty.
    Make sure to create DonationItem instances correctly (e.g., using
    DonationItem.withValues constructor if you added it).

*/