import 'package:capture_photo_from_camera/pages/camera_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'helper/dependencies.dart' as dep;

late List<CameraDescription> cameras;
double screenHeight = Get.context!.height;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraPage = Get.put(CameraPage(cameras: cameras));
    return MaterialApp(
      home: cameraPage,
      debugShowCheckedModeBanner: false,
    );
  }
}

