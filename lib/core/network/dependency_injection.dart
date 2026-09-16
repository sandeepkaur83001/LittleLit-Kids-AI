import 'package:little_kids_ai/core/common_imports.dart';
import 'package:get/get.dart';
import 'package:little_kids_ai/core/services/background_music_service.dart';
import 'package:little_kids_ai/features/auth/controllers/auth_controller.dart';
import 'package:little_kids_ai/features/profile/controllers/profile_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put(DialogService(), permanent: true);
    Get.put<BackgroundMusicService>(BackgroundMusicService(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}

