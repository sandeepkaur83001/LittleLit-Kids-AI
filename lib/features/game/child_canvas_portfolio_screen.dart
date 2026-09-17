import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/controllers/skills_controller.dart';

class ChildCanvasPortfolioScreen extends StatefulWidget {
  final String? childName;

  const ChildCanvasPortfolioScreen({
    super.key,
    this.childName,
  });

  @override
  State<ChildCanvasPortfolioScreen> createState() => _ChildCanvasPortfolioScreenState();
}

class _ChildCanvasPortfolioScreenState extends State<ChildCanvasPortfolioScreen> {
  final SkillsController _skillsController = Get.find<SkillsController>();

  @override
  void initState() {
    super.initState();
    _skillsController.fetchSkills();
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/src_assets_background_home_main.png',
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 6),
                // Top Ribbon Banner
                _buildRibbonHeader(),
                const SizedBox(height: 10),

                // Top Cards (Favorites, Hot Skills, My portfolio)
                _buildTopCardsRow(context),
                const SizedBox(height: 12),

                // 6 Skill Items Grid (2 rows x 3 columns)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      final skills = _skillsController.skillList;
                      if (skills.isEmpty) {
                        return const Center(
                          child: SpinKitThreeBounce(color: Color(0xFF0284C7), size: 24),
                        );
                      }

                      final row1 = skills.take(3).toList();
                      final row2 = skills.skip(3).take(3).toList();

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Row 1
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: row1.asMap().entries.map((entry) {
                              final skill = entry.value;
                              final assetPath = _skillsController.getAssetForSkill(skill, entry.key);
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: entry.key < row1.length - 1 ? 14 : 0,
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _showSkillDetails(context, skill, assetPath),
                                    child: _buildSkillWidget(skill, assetPath),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          // Row 2
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: row2.asMap().entries.map((entry) {
                              final skill = entry.value;
                              final assetPath = _skillsController.getAssetForSkill(skill, entry.key + 3);
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: entry.key < row2.length - 1 ? 14 : 0,
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _showSkillDetails(context, skill, assetPath),
                                    child: _buildSkillWidget(skill, assetPath),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),

            // Top-Right Close Button
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 18),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/images/src_assets_icons_btn_cross.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF80CBC4).withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.black87, size: 24),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRibbonHeader() {
    if (widget.childName != null && widget.childName!.isNotEmpty) {
      return _buildRibbonContent(widget.childName!);
    }

    return Obx(() {
      final effectiveName = Get.find<ProfileController>().userProfile.value?.childNickname ??
          Globals.currentUser?.childNickname ??
          'Child';
      return _buildRibbonContent(effectiveName);
    });
  }

  Widget _buildRibbonContent(String name) {
    return Center(
      child: ClipPath(
        clipper: const RibbonClipper(notchWidth: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
          color: const Color(0xFF38BDF8),
          child: Text(
            "$name's Canvas",
            style: GoogleFonts.comicNeue(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopCardsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Card 1: Favorites
          Expanded(
            flex: 4,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/src_assets_icons_port_favorites.png',
                    height: 58,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.stars_rounded, size: 30, color: Color(0xFFF59E0B)),
                  ),
                  const SizedBox(width: 8),
                  // 3 Slot boxes
                  Expanded(
                    child: Row(
                      children: [
                        _buildSlotBox(),
                        const SizedBox(width: 6),
                        _buildSlotBox(),
                        const SizedBox(width: 6),
                        _buildSlotBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Card 2: Hot Skills
          Expanded(
            flex: 3,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/src_assets_icons_port_hotskills.png',
                    height: 58,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                  const SizedBox(width: 8),
                  // 2 Slot boxes
                  Expanded(
                    child: Row(
                      children: [
                        _buildSlotBox(),
                        const SizedBox(width: 6),
                        _buildSlotBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Card 3: My Portfolio Badge
          Expanded(
            flex: 3,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/src_assets_icons_my_portpolio.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/magic_image.png',
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotBox() {
    return Expanded(
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFCEEEF8).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _buildSkillWidget(SkillModel skill, String assetPath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 65,
          child: AppCardImage(
            imageUrl: skill.iconUrl ?? skill.icon,
            fallbackAsset: assetPath,
            fallbackIcon: Icons.auto_awesome_rounded,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDFF1FD),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            skill.name ?? 'Skill',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.comicNeue(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  void _showSkillDetails(BuildContext context, SkillModel skill, String assetPath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final currentLevel = skill.level ?? 1;
        final maxLevel = skill.maxLevel ?? 6;
        final progress = (currentLevel / maxLevel).clamp(0.0, 1.0);

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: Container(
              width: math.min(MediaQuery.of(context).size.width * 0.85, 340.0),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Skill Icon
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF38BDF8), width: 2),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: AppCardImage(
                      imageUrl: skill.iconUrl ?? skill.icon,
                      fallbackAsset: assetPath,
                      fallbackIcon: Icons.auto_awesome_rounded,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    skill.name ?? 'Skill',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Level $currentLevel of $maxLevel',
                      style: GoogleFonts.comicNeue(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Description
                  if (skill.description != null && skill.description!.isNotEmpty)
                    Text(
                      skill.description!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                        height: 1.3,
                      ),
                    ),
                  const SizedBox(height: 18),

                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Got it!',
                        style: GoogleFonts.comicNeue(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RibbonClipper extends CustomClipper<Path> {
  final double notchWidth;

  const RibbonClipper({this.notchWidth = 16.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - notchWidth, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(notchWidth, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
