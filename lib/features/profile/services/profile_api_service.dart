import 'dart:io';
import 'package:little_kids_ai/core/common_imports.dart';

class ProfileApiService {
  Future<AuthResponseModel> getUser({bool showLoading = false}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.user,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return AuthResponseModel.fromJson(json);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch user: $e',
      );
    }
  }

  Future<AuthResponseModel> getProfile({bool showLoading = true}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.profile,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return AuthResponseModel.fromJson(json);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch profile: $e',
      );
    }
  }

  Future<MoodListResponseModel> getMoods({bool showLoading = false}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.moods,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return MoodListResponseModel.fromJson(json);
    } catch (e) {
      return MoodListResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch moods: $e',
      );
    }
  }

  Future<AuthResponseModel> editProfile({
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
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      if (firstName != null && firstName.isNotEmpty) 'first_name': firstName,
      if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
      if (childId != null) 'child_id': childId.toString(),
      if (childNickname != null && childNickname.isNotEmpty) 'child_nickname': childNickname,
      if (childAge != null) 'child_age': childAge.toString(),
      if (childGrade != null && childGrade.isNotEmpty) 'child_grade': childGrade,
      if (isNeurodivergent != null) 'is_neurodivergent': isNeurodivergent ? '1' : '0',
      if (backgroundMusic != null) 'background_music': backgroundMusic ? '1' : '0',
      if (moodId != null) 'mood_id': moodId.toString(),
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.profile,
      body: body,
      singleFile: profilePicture,
      fileType: 'profile_picture',
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return AuthResponseModel.fromJson(json);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to update profile: $e',
      );
    }
  }

  Future<BaseModel> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.changePassword,
      body: body,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return BaseModel.fromJson(json);
    } catch (e) {
      return BaseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to change password: $e',
      );
    }
  }

  Future<BaseModel> deleteAccount({bool showLoading = true}) async {
    final response = await ApiService.delete(
      ApiEndPointConstants.profile,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return BaseModel.fromJson(json);
    } catch (e) {
      return BaseModel(
        success: response.statusCode == 200,
        status: response.statusCode,
        message: response.statusCode == 200 ? 'Account deleted successfully' : 'Failed to delete account: $e',
      );
    }
  }
}
