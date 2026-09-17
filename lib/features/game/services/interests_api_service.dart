import 'package:little_kids_ai/core/common_imports.dart';

class InterestsApiService {
  Future<InterestListResponseModel> getInterests({bool showLoading = false}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.interests,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return InterestListResponseModel.fromJson(json);
    } catch (e) {
      return InterestListResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch interests: $e',
      );
    }
  }

  Future<SingleInterestResponseModel> getInterestDetails(
    int id, {
    bool showLoading = false,
  }) async {
    final response = await ApiService.get(
      '${ApiEndPointConstants.interests}/$id',
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return SingleInterestResponseModel.fromJson(json);
    } catch (e) {
      return SingleInterestResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch interest details: $e',
      );
    }
  }
}
