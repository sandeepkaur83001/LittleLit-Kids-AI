import 'dart:io';
import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/core/services/background_music_service.dart';
import 'package:little_kids_ai/features/game/auth_choice_screen.dart';

class ProfileController extends GetxController {
  final ProfileApiService _apiService = ProfileApiService();

  final RxBool isLoading = false.obs;
  final Rxn<UserData> userProfile = Rxn<UserData>();
  final RxList<MoodModel> moodList = <MoodModel>[].obs;
  final Rxn<MoodModel> selectedMood = Rxn<MoodModel>();

  @override
  void onInit() {
    super.onInit();
    loadLocalProfile();
    ever(selectedMood, (MoodModel? mood) {
      if (mood?.musicUrl != null && mood!.musicUrl!.isNotEmpty) {
        if (Get.isRegistered<BackgroundMusicService>()) {
          BackgroundMusicService.to.playMoodMusic(mood.musicUrl);
        }
      }
    });
  }

  void loadLocalProfile() {
    if (Globals.currentUser != null) {
      userProfile.value = Globals.currentUser;
      if (Globals.currentUser?.mood != null) {
        selectedMood.value = Globals.currentUser?.mood;
      }
    }
  }

  Future<void> fetchProfile({bool showLoading = false}) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.getProfile(showLoading: showLoading);
      if (response.success == true && response.data != null) {
        userProfile.value = response.data;
        Globals.currentUser = response.data;
        if (response.data?.mood != null) {
          selectedMood.value = response.data?.mood;
        }
        await SharedManager.saveAuthData(response);
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching profile: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> fetchMoods({bool showLoading = false}) async {
    try {
      final response = await _apiService.getMoods(showLoading: showLoading);
      if (response.success == true && response.data != null && response.data!.isNotEmpty) {
        moodList.assignAll(response.data!);
        if (userProfile.value?.moodId != null) {
          final matched = moodList.firstWhereOrNull(
            (m) => m.id == userProfile.value?.moodId,
          );
          if (matched != null) {
            selectedMood.value = matched;
          }
        }
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching moods: $e");
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    File? profilePicture,
    int? childId,
    String? childNickname,
    int? childAge,
    String? childGrade,
    bool? isNeurodivergent,
    bool? backgroundMusic,
    int? moodId,
    int? interestId,
    bool showLoading = true,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiService.editProfile(
        firstName: firstName,
        lastName: lastName,
        profilePicture: profilePicture,
        childId: childId,
        childNickname: childNickname,
        childAge: childAge,
        childGrade: childGrade,
        isNeurodivergent: isNeurodivergent,
        backgroundMusic: backgroundMusic,
        moodId: moodId,
        interestId: interestId,
        showLoading: showLoading,
      );

      if (response.success == true && response.data != null) {
        userProfile.value = response.data;
        Globals.currentUser = response.data;
        if (response.data?.mood != null) {
          selectedMood.value = response.data?.mood;
        }
        await SharedManager.saveAuthData(response);

        // Also sync with AuthController
        if (Get.isRegistered<AuthController>()) {
          Get.find<AuthController>().currentUser.value = response.data;
        }

        CustomToast.showSuccessToast(
          msg: response.message ?? "Profile updated successfully!",
        );
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to update profile.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setMood(MoodModel mood) async {
    selectedMood.value = mood;
    if (mood.id != null) {
      return await updateProfile(
        moodId: mood.id,
        showLoading: false,
      );
    }
    return false;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiService.changePassword(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response.success == true) {
        CustomToast.showSuccessToast(
          msg: response.message ?? "Password changed successfully!",
        );
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to change password.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAccount({BuildContext? context}) async {
    isLoading.value = true;
    try {
      final response = await _apiService.deleteAccount();
      if (response.success == true) {
        await SharedManager.clearAuthData();
        userProfile.value = null;
        Globals.currentUser = null;

        if (Get.isRegistered<AuthController>()) {
          final authController = Get.find<AuthController>();
          authController.currentUser.value = null;
          authController.isLoggedIn.value = false;
        }

        CustomToast.showSuccessToast(
          msg: response.message ?? "Account deleted successfully.",
        );

        if (context != null && context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthChoiceScreen()),
            (route) => false,
          );
        } else {
          Get.offAll(() => const AuthChoiceScreen());
        }
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to delete account.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Error deleting account: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
