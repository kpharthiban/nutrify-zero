import 'dart:async'; // For Future
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import camera package
import '../../widgets/custom_app_bar.dart'; // Assuming this exists

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  List<CameraDescription>? cameras; // List of available cameras
  CameraController? _controller; // Camera controller
  Future<void>? _initializeControllerFuture; // Future for controller initialization

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe lifecycle changes
    _initializeCamera(); // Start camera initialization
  }

  // Initialize Camera
  Future<void> _initializeCamera() async {
    // Ensure cameras are available
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        print('Error: No cameras found');
        // Handle no cameras found error (e.g., show a message)
        if (mounted) {
          setState(() {}); // Trigger rebuild to show error message if needed
        }
        return;
      }

      // Select the first back camera
      final firstCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras!.first, // Fallback to first camera if no back camera
      );

      // Create and initialize the CameraController
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high, // Choose appropriate resolution
        enableAudio: false, // Disable audio if only taking pictures
      );

      // Assign the initialization Future
      _initializeControllerFuture = _controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {}); // Trigger rebuild once initialized
      }).catchError((Object e) {
         if (e is CameraException) {
           switch (e.code) {
             case 'CameraAccessDenied':
               print('Error: Camera access denied.');
               // Handle access errors here.
               break;
             default:
               print('Error initializing camera: ${e.code}');
               // Handle other errors here.
               break;
           }
         } else {
            print('Unknown error initializing camera: $e');
         }
         if (mounted) {
           setState((){}); // Update UI to potentially show error
         }
      });

    } catch (e) {
       print('Error fetching cameras: $e');
       if (mounted) {
         setState(() {}); // Update UI to potentially show error
       }
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera controller when app is resumed
       _initializeCamera(); // Re-initialize or create new controller instance
    }
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _controller?.dispose(); // Dispose controller when widget is disposed
    super.dispose();
  }

  // Function to take picture
  Future<void> _takePicture() async {
    // Ensure controller is initialized before attempting to take picture
    await _initializeControllerFuture;

    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: Camera controller is not initialized.');
      return;
    }

    // Prevent taking picture if already in progress
    if (_controller!.value.isTakingPicture) {
      return;
    }

    try {
      // Attempt to take a picture and get the file `XFile` where it was saved.
      final XFile imageFile = await _controller!.takePicture();

      // If the picture was taken, process it (e.g., display, analyze)
      print('Picture saved to ${imageFile.path}');

      // TODO: Navigate to a new screen to display/analyze the image
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => AnalysisScreen(imagePath: imageFile.path),
      //   ),
      // );

       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Picture taken! Path: ${imageFile.path} (Placeholder)')),
       );


    } on CameraException catch (e) {
      // Log errors to the console.
      print('Error taking picture: ${e.code}, ${e.description}');
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: ${e.description}')),
       );
    } catch (e) {
       print('Unknown error taking picture: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unknown error occurred.')),
       );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Your custom app bar
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // Check if the controller is initialized and ready
          if (snapshot.connectionState == ConnectionState.done && _controller != null && _controller!.value.isInitialized) {
            // --- Camera Preview and Overlays ---
            return Stack(
              fit: StackFit.expand, // Make stack fill the body
              children: <Widget>[
                // Camera Preview - Use AspectRatio to avoid distortion
                 Center( // Center the preview
                   child: AspectRatio(
                     aspectRatio: _controller!.value.aspectRatio,
                     child: CameraPreview(_controller!),
                   ),
                 ),

                // --- Overlay Hint Text ---
                Align(
                  alignment: Alignment(0.0, 0.8), // Position near bottom center
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent background
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: const Text(
                      'Take picture to analyze food',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),

                // --- Capture Button ---
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0), // Space from bottom
                    child: InkWell( // Using InkWell for standard ripple effect
                      onTap: _takePicture,
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(4.0), // Outer padding for border effect
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3), // Outer white circle
                        ),
                        child: Container(
                          width: 65, // Inner circle size
                          height: 65,
                           decoration: const BoxDecoration(
                            color: Colors.white, // Inner white circle
                            shape: BoxShape.circle,
                           ),
                           // Optional: add inner icon if needed
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError || (snapshot.connectionState != ConnectionState.waiting && (_controller == null || cameras == null))) {
             // --- Error State ---
            return const Center(
              child: Text(
                'Error initializing camera.\nPlease ensure permissions are granted.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            // --- Loading State ---
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}