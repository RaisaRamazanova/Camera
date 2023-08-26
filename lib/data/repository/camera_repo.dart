import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class CameraRepo extends GetxService {
  final ApiClient appClient;
  CameraRepo({ required this.appClient});

  Future<Response> sendData(String comment, double latitude, double longitude, XFile photo) async {
    FormData body = FormData({
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'photo': MultipartFile(File(photo.path), filename: photo.name),
    });
    return await appClient.sendData(AppConstants.PHOTO_URI, body);
  }
}