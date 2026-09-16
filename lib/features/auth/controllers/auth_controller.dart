import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/core/services/background_music_service.dart';
import 'package:little_kids_ai/features/auth/services/auth_api_service.dart';
import 'package:little_kids_ai/features/game/auth_choice_screen.dart';
import 'package:little_kids_ai/features/game/game_screen.dart';
import 'package:little_kids_ai/models/base_model.dart';
import 'package:little_kids_ai/models/user_model.dart';

class AuthController extends GetxController {
  final AuthApiService _apiService = AuthApiService();
  final SocialSignIn _socialSignIn = SocialSignIn();

  final RxBool isLoading = false.obs;
  final Rxn<UserData> currentUser = Rxn<UserData>();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<bool> checkAuthStatus() async {
    final hasToken = await SharedManager.getToken();
    final user = await SharedManager.getUserData();
    if (hasToken && user != null) {
      currentUser.value = user;
      isLoggedIn.value = true;
      return true;
    }
    isLoggedIn.value = false;
    return false;
  }

  Future<bool> login({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiService.login(
        email: email.trim(),
        password: password,
      );

      if (response.success == true && response.data != null) {
        await SharedManager.saveAuthData(response);
        currentUser.value = response.data;
        isLoggedIn.value = true;

        CustomToast.showSuccessToast(
          msg: response.message ?? "Logged in successfully!",
        );

        if (context != null && context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
            (route) => false,
          );
        } else {
          Get.offAll(() => const GameScreen());
        }
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Login failed. Please check credentials.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Login error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String childNickname,
    required int childAge,
    String? childGrade,
    bool isNeurodivergent = false,
    required String parentEmail,
    required String password,
    bool termsAccepted = true,
    BuildContext? context,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiService.register(
        childNickname: childNickname.trim(),
        childAge: childAge,
        childGrade: childGrade,
        isNeurodivergent: isNeurodivergent,
        parentEmail: parentEmail.trim(),
        password: password,
        termsAccepted: termsAccepted,
      );

      if (response.success == true && response.data != null) {
        await SharedManager.saveAuthData(response);
        currentUser.value = response.data;
        isLoggedIn.value = true;

        CustomToast.showSuccessToast(
          msg: response.message ?? "Registration successful!",
        );

        if (context != null && context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
            (route) => false,
          );
        } else {
          Get.offAll(() => const GameScreen());
        }
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Registration failed.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Registration error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle({
    String? childNickname,
    int? childAge,
    String? childGrade,
    bool? isNeurodivergent,
    BuildContext? context,
  }) async {
    isLoading.value = true;
    try {
      final firebaseUser = await _socialSignIn.signInWithGoogle();
      if (firebaseUser == null) {
        isLoading.value = false;
        return false;
      }

      final response = await _apiService.socialLogin(
        provider: 'google',
        providerId: firebaseUser.uid,
        email: firebaseUser.email,
        firstName: firebaseUser.displayName?.split(' ').first,
        lastName: (firebaseUser.displayName?.split(' ').length ?? 0) > 1
            ? firebaseUser.displayName?.split(' ').sublist(1).join(' ')
            : null,
        childNickname: childNickname,
        childAge: childAge,
        childGrade: childGrade,
        isNeurodivergent: isNeurodivergent,
        termsAccepted: true,
      );

      if (response.success == true && response.data != null) {
        await SharedManager.saveAuthData(response);
        currentUser.value = response.data;
        isLoggedIn.value = true;

        CustomToast.showSuccessToast(
          msg: response.message ?? "Welcome!",
        );

        if (context != null && context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
            (route) => false,
          );
        } else {
          Get.offAll(() => const GameScreen());
        }
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Social sign-in failed.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Google sign-in error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithApple({
    String? childNickname,
    int? childAge,
    String? childGrade,
    bool? isNeurodivergent,
    BuildContext? context,
  }) async {
    isLoading.value = true;
    try {
      final firebaseUser = await _socialSignIn.signInWithApple();
      if (firebaseUser == null) {
        isLoading.value = false;
        return false;
      }

      final response = await _apiService.socialLogin(
        provider: 'apple',
        providerId: firebaseUser.uid,
        email: firebaseUser.email,
        firstName: firebaseUser.displayName,
        childNickname: childNickname,
        childAge: childAge,
        childGrade: childGrade,
        isNeurodivergent: isNeurodivergent,
        termsAccepted: true,
      );

      if (response.success == true && response.data != null) {
        await SharedManager.saveAuthData(response);
        currentUser.value = response.data;
        isLoggedIn.value = true;

        CustomToast.showSuccessToast(
          msg: response.message ?? "Welcome!",
        );

        if (context != null && context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const GameScreen()),
            (route) => false,
          );
        } else {
          Get.offAll(() => const GameScreen());
        }
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Apple sign-in failed.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Apple sign-in error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> forgotPassword({
    required String email,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiService.forgotPassword(email: email.trim());
      if (response.success == true) {
        CustomToast.showSuccessToast(
          msg: response.message ?? "Password reset instructions sent to your email.",
        );
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to request password reset.",
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

  Future<bool> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiService.resetPassword(
        token: token.trim(),
        email: email.trim(),
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      if (response.success == true) {
        CustomToast.showSuccessToast(
          msg: response.message ?? "Password has been reset successfully. Please login.",
        );
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to reset password.",
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

  Future<void> logout({BuildContext? context}) async {
    isLoading.value = true;
    try {
      await _apiService.logout();
      await _socialSignIn.signOut();
    } catch (e) {
      CommonApiClass().normalPrintJson("Logout error: $e");
    } finally {
      await SharedManager.clearAuthData();
      if (Get.isRegistered<BackgroundMusicService>()) {
        await BackgroundMusicService.to.stopMusic();
      }
      currentUser.value = null;
      isLoggedIn.value = false;
      isLoading.value = false;

      CustomToast.showSuccessToast(msg: "Logged out successfully");

      if (context != null && context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthChoiceScreen()),
          (route) => false,
        );
      } else {
        Get.offAll(() => const AuthChoiceScreen());
      }
    }
  }
}
