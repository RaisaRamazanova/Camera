import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../controllers/photo_camera_controller.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  final commentController = TextEditingController();
  String _text = "";
  Position? _currentPosition;

  void _setText() {
    setState(() {
      _text = commentController.text;
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      debugPrint('ERROR: $e');
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    _controller = CameraController(Get.find<CameraPage>().cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object error) {
      printError(info: error.toString());
      if (error is CameraException) {
        switch (error.code) {
          case 'CameraAccessDenied':
            print('access was denied');
            break;
          default:
            print(error.description);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container (
              margin: const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 200),
              child: Center(
                child: CameraPreview(_controller),
              )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child:
                  TextField(
                    controller: commentController,
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter a comment...',
                    ),
                  )
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: MaterialButton(
                    color: Colors.grey,
                    child: const Text(
                      "Send data",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: () async {
                      _setText;
                      if (!_controller.value.isInitialized) {
                        printError(info: 'Controller value is not initialized');
                        return null;
                      }
                      try {
                        await _controller.setFlashMode(FlashMode.auto);
                        XFile picture = await _controller.takePicture();
                        Get.find<PhotoCameraController>().sendData(
                            context,
                            _text,
                            _currentPosition?.latitude ?? 0.0,
                            _currentPosition?.longitude ?? 0.0,
                            picture);
                      } on CameraException catch (error) {
                        printError(info: error.description!);
                        Get.snackbar(
                            "Error", "Failed to send data",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white);
                        return null;
                      }
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}