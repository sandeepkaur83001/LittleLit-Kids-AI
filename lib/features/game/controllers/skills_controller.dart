import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/services/skills_api_service.dart';

class SkillsController extends GetxController {
  final SkillsApiService _apiService = SkillsApiService();

  final RxBool isLoading = false.obs;
  final RxList<SkillModel> skillList = <SkillModel>[].obs;

  static const List<String> defaultSkillTitles = [
    'Curiosity',
    'Problem Solving',
    'Creativity',
    'Self Expression',
    'Initiative',
    'Persistence',
  ];

  @override
  void onInit() {
    super.onInit();
    _initDefaultSkills();
    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) {
      fetchSkills();
    }
  }

  void _initDefaultSkills() {
    skillList.assignAll(
      List.generate(defaultSkillTitles.length, (index) {
        return SkillModel(
          id: index + 1,
          name: defaultSkillTitles[index],
          slug: defaultSkillTitles[index].toLowerCase().replaceAll(' ', '-'),
          level: 1,
          minLevel: 1,
          maxLevel: 6,
          sortOrder: index + 1,
          isActive: true,
        );
      }),
    );
  }

  Future<void> fetchSkills({bool showLoading = false}) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.getSkills(showLoading: showLoading);
      if (response.success == true && response.data != null && response.data!.isNotEmpty) {
        skillList.assignAll(response.data!);
      }
    } catch (e) {
      CommonApiClass().normalPrintJson("Error fetching skills: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  String getAssetForSkill(SkillModel skill, [int? index]) {
    final lvl = (skill.level != null && skill.level! > 0) ? skill.level! : 1;
    final clampedLevel = lvl.clamp(1, 6);
    return 'assets/images/src_assets_icons_port$clampedLevel.png';
  }
}
