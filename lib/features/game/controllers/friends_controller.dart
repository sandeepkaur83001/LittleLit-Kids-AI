import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/services/friends_api_service.dart';

class FriendsController extends GetxController {
  final FriendsApiService _apiService = FriendsApiService();

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxList<FriendModel> friendsList = <FriendModel>[].obs;
  final RxList<FriendModel> pendingRequests = <FriendModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) {
      fetchFriends();
      fetchPendingRequests();
    }
  }

  String get mySecretKey {
    final user = Globals.currentUser ?? Get.find<ProfileController>().userProfile.value;
    if (user?.secretKey != null && user!.secretKey!.isNotEmpty) {
      return user.secretKey!;
    }
    final name = user?.childNickname ?? user?.firstName ?? 'Kid';
    final id = user?.id ?? 101;
    return '$name$id';
  }

  Future<void> fetchFriends({bool showLoading = false}) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.getFriends(showLoading: showLoading);
      if (response.success == true && response.data != null) {
        friendsList.assignAll(response.data!);
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching friends: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> fetchPendingRequests({bool showLoading = false}) async {
    try {
      final response = await _apiService.getFriendRequests(showLoading: showLoading);
      if (response.success == true && response.data != null) {
        pendingRequests.assignAll(response.data!);
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching pending requests: $e");
    }
  }

  Future<bool> sendFriendRequest(String secretKey) async {
    if (secretKey.trim().isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter friend's secret key");
      return false;
    }

    isSubmitting.value = true;
    try {
      final response = await _apiService.sendFriendRequest(secretKey.trim());
      if (response.success == true) {
        CustomToast.showSuccessToast(
          msg: response.message ?? "Friend request sent successfully!",
        );
        fetchFriends();
        fetchPendingRequests();
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to send friend request.",
        );
        return false;
      }
    } catch (e) {
      CustomToast.showErrorToast(msg: "Error: $e");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> acceptRequest(int userId) async {
    isLoading.value = true;
    try {
      final response = await _apiService.acceptFriendRequest(userId);
      if (response.success == true) {
        CustomToast.showSuccessToast(
          msg: response.message ?? "Friend request accepted!",
        );
        fetchFriends();
        fetchPendingRequests();
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to accept request.",
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

  Future<bool> rejectRequest(int userId) async {
    isLoading.value = true;
    try {
      final response = await _apiService.rejectFriendRequest(userId);
      if (response.success == true) {
        CustomToast.showSuccessToast(
          msg: response.message ?? "Friend request rejected.",
        );
        fetchPendingRequests();
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to reject request.",
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

  Future<bool> deleteFriend(int friendId) async {
    isLoading.value = true;
    try {
      final response = await _apiService.removeFriend(friendId);
      if (response.success == true) {
        CustomToast.showSuccessToast(
          msg: response.message ?? "Friend removed successfully.",
        );
        friendsList.removeWhere((f) => f.id == friendId);
        return true;
      } else {
        CustomToast.showErrorToast(
          msg: response.message ?? "Failed to remove friend.",
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
}
