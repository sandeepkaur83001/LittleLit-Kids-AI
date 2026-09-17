import 'package:little_kids_ai/core/common_imports.dart';

class CategoriesApiService {
  Future<CategoryListResponseModel> getCategories({bool showLoading = false}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.categories,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return CategoryListResponseModel.fromJson(json);
    } catch (e) {
      return CategoryListResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch categories: $e',
      );
    }
  }

  Future<CategoryListResponseModel> getCategoriesByParentId(
    int parentId, {
    bool showLoading = false,
  }) async {
    final response = await ApiService.get(
      '${ApiEndPointConstants.categories}?parent_id=$parentId',
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return CategoryListResponseModel.fromJson(json);
    } catch (e) {
      return CategoryListResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch sub-categories: $e',
      );
    }
  }

  Future<SingleCategoryResponseModel> getCategoryDetails(
    int id, {
    bool showLoading = false,
  }) async {
    final response = await ApiService.get(
      '${ApiEndPointConstants.categories}/$id',
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return SingleCategoryResponseModel.fromJson(json);
    } catch (e) {
      return SingleCategoryResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch category details: $e',
      );
    }
  }
}
