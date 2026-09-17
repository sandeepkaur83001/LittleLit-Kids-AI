import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/services/categories_api_service.dart';

class CategoriesController extends GetxController {
  final CategoriesApiService _apiService = CategoriesApiService();

  final RxBool isLoading = false.obs;
  final RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  final RxMap<int, List<CategoryModel>> subCategoriesMap = <int, List<CategoryModel>>{}.obs;
  final Rxn<CategoryModel> selectedCategory = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchCategories({bool showLoading = false}) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.getCategories(showLoading: showLoading);
      if (response.success == true && response.data != null && response.data!.isNotEmpty) {
        categoryList.assignAll(response.data!);
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching categories: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<List<CategoryModel>> fetchCategoriesByParentId(int parentId, {bool showLoading = false}) async {
    try {
      final response = await _apiService.getCategoriesByParentId(parentId, showLoading: showLoading);
      if (response.success == true && response.data != null) {
        subCategoriesMap[parentId] = response.data!;
        return response.data!;
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching subcategories for parent $parentId: $e");
    }
    return [];
  }
}
