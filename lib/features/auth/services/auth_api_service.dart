import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/models/base_model.dart';
import 'package:little_kids_ai/models/user_model.dart';

class AuthApiService {
  Future<AuthResponseModel> socialLogin({
    required String provider,
    required String providerId,
    String? email,
    String? firstName,
    String? lastName,
    String? childNickname,
    int? childAge,
    String? childGrade,
    bool? isNeurodivergent,
    bool termsAccepted = true,
    String? deviceToken,
    String? deviceType,
    String? latitude,
    String? longitude,
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'provider': provider,
      'provider_id': providerId,
      if (email != null && email.isNotEmpty) 'email': email,
      if (firstName != null && firstName.isNotEmpty) 'first_name': firstName,
      if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
      if (childNickname != null && childNickname.isNotEmpty) 'child_nickname': childNickname,
      if (childAge != null) 'child_age': childAge.toString(),
      if (childGrade != null && childGrade.isNotEmpty) 'child_grade': childGrade,
      if (isNeurodivergent != null) 'is_neurodivergent': isNeurodivergent ? '1' : '0',
      'terms_accepted': termsAccepted ? '1' : '0',
      if (deviceToken != null && deviceToken.isNotEmpty) 'device_token': deviceToken,
      if (deviceType != null && deviceType.isNotEmpty) 'device_type': deviceType,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.socialLogin,
      body: body,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return AuthResponseModel.fromJson(json);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to process social login response: $e',
      );
    }
  }

  Future<AuthResponseModel> register({
    required String childNickname,
    required int childAge,
    String? childGrade,
    bool isNeurodivergent = false,
    required String parentEmail,
    required String password,
    bool termsAccepted = true,
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'child_nickname': childNickname,
      'child_age': childAge.toString(),
      if (childGrade != null && childGrade.isNotEmpty) 'child_grade': childGrade,
      'is_neurodivergent': isNeurodivergent ? '1' : '0',
      'parent_email': parentEmail,
      'password': password,
      'terms_accepted': termsAccepted ? '1' : '0',
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.register,
      body: body,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return AuthResponseModel.fromJson(json);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to process register response: $e',
      );
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.login,
      body: body,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return AuthResponseModel.fromJson(json);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to process login response: $e',
      );
    }
  }

  Future<BaseModel> forgotPassword({
    required String email,
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.forgotPassword,
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
        message: 'Failed to process forgot password response: $e',
      );
    }
  }

  Future<BaseModel> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.resetPassword,
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
        message: 'Failed to process reset password response: $e',
      );
    }
  }

  Future<BaseModel> logout({bool showLoading = true}) async {
    final response = await ApiService.post(
      ApiEndPointConstants.logout,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return BaseModel.fromJson(json);
    } catch (e) {
      return BaseModel(
        success: response.statusCode == 200,
        status: response.statusCode,
        message: response.statusCode == 200 ? 'Logged out successfully' : 'Failed to logout: $e',
      );
    }
  }
}
