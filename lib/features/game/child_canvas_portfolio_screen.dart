import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class ChildCanvasPortfolioScreen extends StatelessWidget {
  final String childName;

  const ChildCanvasPortfolioScreen({
    super.key,
    this.childName = 'Test',
  });

  final List<Map<String, dynamic>> _skills = const [
    {'title': 'Curiosity', 'stars': 6},
    {'title': 'Problem Solving', 'stars': 6},
    {'title': 'Creativity', 'stars': 6},
    {'title': 'Self Expression', 'stars': 6},
    {'title': 'Initiative', 'stars': 6},
    {'title': 'Persistence', 'stars': 6},
  ];

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 6),
                // Top Ribbon: "[ChildName] 's Canvas"
                _buildRibbonHeader(),
                const SizedBox(height: 10),

                // Top Cards (Favorites, Hot Skills, My portfolio)
                _buildTopCardsRow(context),
                const SizedBox(height: 14),

                // 6 Skill Progress Bars Grid (2 rows x 3 columns)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Row 1 (Curiosity, Problem Solving, Creativity)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildSkillWidget(_skills[0])),
                            const SizedBox(width: 14),
                            Expanded(child: _buildSkillWidget(_skills[1])),
                            const SizedBox(width: 14),
                            Expanded(child: _buildSkillWidget(_skills[2])),
                          ],
                        ),
                        // Row 2 (Self Expression, Initiative, Persistence)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _buildSkillWidget(_skills[3])),
                            const SizedBox(width: 14),
                            Expanded(child: _buildSkillWidget(_skills[4])),
                            const SizedBox(width: 14),
                            Expanded(child: _buildSkillWidget(_skills[5])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),

            // Top-Right Close Button
            Positioned(
              top: 8,
              right: 18,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/images/src_assets_icons_btn_cross.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF80CBC4).withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.black87, size: 24),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF29B6F6),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        "$childName 's Canvas",
        style: GoogleFonts.comicNeue(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF08A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'THIS WEEK',
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Color(0xFF854D0E)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/src_assets_icons_port_favorites.png',
                            height: 18,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.stars_rounded, size: 18, color: Color(0xFFF59E0B)),
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Favorites',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFBE185D)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // 3 Slot boxes
                  Expanded(
                    child: Row(
                      children: [
                        _buildSlotBox(),
                        const SizedBox(width: 4),
                        _buildSlotBox(),
                        const SizedBox(width: 4),
                        _buildSlotBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Card 2: Hot Skills
          Expanded(
            flex: 3,
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF08A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'THIS WEEK',
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Color(0xFF854D0E)),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/src_assets_icons_port_hotskills.png',
                            height: 18,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            'Hot Skills',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // 2 Slot boxes
                  Expanded(
                    child: Row(
                      children: [
                        _buildSlotBox(),
                        const SizedBox(width: 4),
                        _buildSlotBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Card 3: My Portfolio Badge
          Expanded(
            flex: 3,
            child: Container(
              height: 72,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/src_assets_icons_my_portpolio.png',
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/magic_image.png',
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'My\nportfolio',
                    style: GoogleFonts.comicNeue(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0284C7),
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40), // Space for close button
        ],
      ),
    );
  }

  Widget _buildSlotBox() {
    return Expanded(
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFB2EBF2).withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF80DEEA), width: 1.0),
        ),
      ),
    );
  }

  Widget _buildSkillWidget(Map<String, dynamic> skill) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star Blocks Bar with Mascot sitting on block 1
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomLeft,
          children: [
            // Mascot
            Positioned(
              top: -24,
              left: 4,
              child: Image.asset(
                'assets/images/src_assets_icons_char_litto.png',
                height: 32,
                width: 32,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.smart_toy_rounded,
                  size: 24,
                  color: Colors.blue.shade400,
                ),
              ),
            ),

            // 6 Star Blocks
            Row(
              children: [
                _buildStarCube(const Color(0xFF0284C7), true),
                const SizedBox(width: 2),
                _buildStarCube(const Color(0xFFFDE047), true),
                const SizedBox(width: 2),
                _buildStarCube(const Color(0xFF0284C7), true),
                const SizedBox(width: 2),
                _buildStarCube(const Color(0xFF38BDF8), true),
                const SizedBox(width: 2),
                _buildStarCube(const Color(0xFFFDE047), true),
                const SizedBox(width: 2),
                _buildStarCube(const Color(0xFF0284C7), true),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Title Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1.0),
          ),
          child: Text(
            skill['title'],
            style: GoogleFonts.comicNeue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStarCube(Color color, bool hasStar) {
    return Expanded(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: hasStar
            ? Center(
                child: Image.asset(
                  'assets/images/src_assets_icons_litto_star.png',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: Color(0xFFFACC15),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
