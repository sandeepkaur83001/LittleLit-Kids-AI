import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class ChildCanvasPortfolioScreen extends StatelessWidget {
  final String childName;

  const ChildCanvasPortfolioScreen({
    super.key,
    this.childName = 'Test',
  });

  final List<Map<String, dynamic>> _skills = const [
    {
      'title': 'Curiosity',
      'asset': 'assets/images/src_assets_icons_port1.png',
    },
    {
      'title': 'Problem Solving',
      'asset': 'assets/images/src_assets_icons_port2.png',
    },
    {
      'title': 'Creativity',
      'asset': 'assets/images/src_assets_icons_port3.png',
    },
    {
      'title': 'Self Expression',
      'asset': 'assets/images/src_assets_icons_port4.png',
    },
    {
      'title': 'Initiative',
      'asset': 'assets/images/src_assets_icons_port5.png',
    },
    {
      'title': 'Persistence',
      'asset': 'assets/images/src_assets_icons_port6.png',
    },
  ];

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
                // Top Ribbon Banner: src_assets_icons_port_name
                _buildRibbonHeader(),
                const SizedBox(height: 10),

                // Top Cards (Favorites, Hot Skills, My portfolio)
                _buildTopCardsRow(context),
                const SizedBox(height: 12),

                // 6 Skill Items Grid (2 rows x 3 columns)
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
                const SizedBox(height: 10),
              ],
            ),

            // Top-Right Close Button
            Positioned(
              top: 10,
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
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/src_assets_icons_port_name.png',
            height: 44,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF29B6F6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const SizedBox(width: 140),
            ),
          ),
          Text(
            "$childName 's Canvas",
            style: GoogleFonts.comicNeue(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
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
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/src_assets_icons_port_favorites.png',
                    height: 58,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.stars_rounded, size: 30, color: Color(0xFFF59E0B)),
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
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/src_assets_icons_port_hotskills.png',
                    height: 58,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
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
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/src_assets_icons_my_portpolio.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
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
          color: const Color(0xFFCEEEF8).withOpacity(0.85),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _buildSkillWidget(Map<String, dynamic> skill) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          skill['asset'] as String,
          height: 65,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFDFF1FD),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            skill['title'] as String,
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
}
