import 'package:camera/camera.dart';
import 'package:capture_photo_from_camera/data/repository/camera_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoCameraController extends GetxController {
  final CameraRepo cameraRepo;

  PhotoCameraController({ required this.cameraRepo});

  void showsnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> sendData(BuildContext context, String comment, double latitude, double longitude, XFile photo) async {
    Response response = await cameraRepo.sendData(comment, latitude, longitude, photo);
    switch (response.statusCode) {
      case 201:
        Future.delayed(Duration.zero)
            .then((value) => showsnackbar(context, "Succeeded in sending data"));
      default:
        Future.delayed(Duration.zero)
            .then((value) => showsnackbar(context, "Failed to send data"));
    }
  }
}