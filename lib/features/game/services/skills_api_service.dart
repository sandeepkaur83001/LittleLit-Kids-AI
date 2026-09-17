import 'package:little_kids_ai/core/common_imports.dart';

class SkillsApiService {
  Future<SkillListResponseModel> getSkills({bool showLoading = false}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.skills,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return SkillListResponseModel.fromJson(json);
    } catch (e) {
      return SkillListResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch skills: $e',
      );
    }
  }
}
