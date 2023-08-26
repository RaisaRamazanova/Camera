import 'package:capture_photo_from_camera/data/repository/camera_repo.dart';
import 'package:get/get.dart';
import '../controllers/photo_camera_controller.dart';
import '../data/api/api_client.dart';
import '../utils/app_constants.dart';

Future<void> init() async {

  // api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL));

  // repos
  Get.lazyPut(() => CameraRepo(appClient: Get.find()));

  // controllers
  Get.lazyPut(() => PhotoCameraController(cameraRepo: Get.find()));
}