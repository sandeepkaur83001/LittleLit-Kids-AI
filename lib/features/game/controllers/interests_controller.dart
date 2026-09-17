import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/services/interests_api_service.dart';

class InterestsController extends GetxController {
  final InterestsApiService _apiService = InterestsApiService();

  final RxBool isLoading = false.obs;
  final RxList<InterestModel> interestList = <InterestModel>[].obs;
  final Rxn<InterestModel> selectedInterest = Rxn<InterestModel>();

  // Default color palette for the 8 interest pills
  static const List<Color> interestColors = [
    Color(0xFFFFB7B7), // Book - soft pink
    Color(0xFFFFE897), // Music - pastel yellow
    Color(0xFFF0FAD1), // Magic Art - light lime
    Color(0xFFC5E1A5), // Ask Litto - soft green
    Color(0xFFB2EBF2), // STEM Projects - light cyan
    Color(0xFF80CBC4), // Puzzles - teal
    Color(0xFFF5F5F5), // Designs - light grey/white
    Color(0xFFFFE082), // Art - amber/yellow
  ];

  @override
  void onInit() {
    super.onInit();
    _initDefaultInterests();
    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) {
      fetchInterests();
    }
  }

  void _initDefaultInterests() {
    final defaultTitles = [
      'Book',
      'Music',
      'Magic Art',
      'Ask Litto',
      'STEM Projects',
      'Puzzles',
      'Designs',
      'Art',
    ];
    interestList.assignAll(
      List.generate(defaultTitles.length, (index) {
        return InterestModel(
          id: index + 1,
          name: defaultTitles[index],
          slug: defaultTitles[index].toLowerCase().replaceAll(' ', '-'),
          sortOrder: index + 1,
          isActive: true,
          isSelected: index == 0,
        );
      }),
    );
    selectedInterest.value = interestList.first;
  }

  Future<void> fetchInterests({bool showLoading = false}) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.getInterests(showLoading: showLoading);
      if (response.success == true && response.data != null && response.data!.isNotEmpty) {
        interestList.assignAll(response.data!);
        
        // Find selected interest if indicated by backend or user profile
        final selected = interestList.firstWhereOrNull((i) => i.isSelected == true);
        if (selected != null) {
          selectedInterest.value = selected;
        } else if (Globals.currentUser?.interestId != null) {
          final matched = interestList.firstWhereOrNull((i) => i.id == Globals.currentUser?.interestId);
          if (matched != null) {
            selectedInterest.value = matched;
          }
        }
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching interests: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> selectInterest(InterestModel interest, {bool updateBackend = true}) async {
    selectedInterest.value = interest;
    for (var item in interestList) {
      item.isSelected = (item.id == interest.id);
    }
    interestList.refresh();

    if (updateBackend && interest.id != null && Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) {
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().updateProfile(
          interestId: interest.id,
          showLoading: false,
        );
      }
    }
  }

  Color getColorForIndex(int index) {
    if (index >= 0 && index < interestColors.length) {
      return interestColors[index];
    }
    return const Color(0xFFB2EBF2);
  }
}
