import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/settings_screen.dart';
import 'package:little_kids_ai/features/game/tune_selection_screen.dart';
import 'package:little_kids_ai/features/game/book_creation_screen.dart';
import 'package:little_kids_ai/features/game/widgets/voice_help_overlay.dart';
import 'package:little_kids_ai/features/game/widgets/competition_overlay.dart';
import 'package:little_kids_ai/features/game/widgets/mood_bottom_sheet.dart';
import 'package:little_kids_ai/features/game/reward_screen.dart';
import 'package:little_kids_ai/features/game/category_selection_screen.dart';
import 'package:little_kids_ai/features/game/portfolio_screen.dart';
import 'package:little_kids_ai/features/game/magic_art_screen.dart';
import 'package:little_kids_ai/features/game/coloring_art_screen.dart';
import 'package:little_kids_ai/features/game/coloring_theme_selection_screen.dart';
import 'package:little_kids_ai/features/game/puzzle_game_screen.dart';

import 'package:little_kids_ai/features/game/design_apparel_selection_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _magicGlowController;

  final List<Map<String, dynamic>> games = [
    {'title': 'Make Posters', 'image': 'assets/images/make_posters.png', 'screen': const MagicArtScreen()},
    {'title': 'Write Storybook', 'image': 'assets/images/write_storybooks.png', 'screen': const BookCreationScreen()},
    {'title': 'Design Puzzles', 'image': 'assets/images/design_puzzels.png', 'screen': const PuzzleGameScreen()},
    {'title': 'Design Stuff', 'image': 'assets/images/design_stuff.png', 'screen': const DesignApparelSelectionScreen()},
    {'title': 'Create Songs', 'image': 'assets/images/create_songs.png', 'screen': const TuneSelectionScreen()},
    {'title': 'Coloring Art', 'image': 'assets/images/coloring_arts.png', 'screen': const ColoringThemeSelectionScreen()},
    {'title': 'Build Projects', 'image': 'assets/images/build_projects.png', 'screen': const PuzzleGameScreen()},
  ];

  late PageController _pageController;
  double _currentPage = 2.0; // Focus on 'Design Puzzles' or 'Create Songs'

  @override
  void initState() {
    super.initState();
    _magicGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pageController = PageController(
      initialPage: 2,
      viewportFraction: 0.23,
    );

    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? 2.0;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CompetitionOverlay(),
      );
    });
  }

  @override
  void dispose() {
    _magicGlowController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: "assets/images/landscape_background_clean.png",
      child: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double slotWidth = width * 0.23;
                final double itemWidth = slotWidth - 6.0;

                return PageView.builder(
                  controller: _pageController,
                  itemCount: games.length,
                  physics: const BouncingScrollPhysics(),
                  padEnds: true,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double pageOffset = 0.0;
                        if (_pageController.position.haveDimensions) {
                          pageOffset = (_pageController.page ?? _pageController.initialPage.toDouble()) - index;
                        } else {
                          pageOffset = (_currentPage - index);
                        }

                        // Smooth curve for scale, elevation, and pop
                        final double progress = (1.0 - (pageOffset.abs() * 0.75)).clamp(0.0, 1.0);
                        final double scale = 0.88 + (progress * 0.18);
                        final double yOffset = -20.0 * progress;
                        final bool isSelected = pageOffset.abs() < 0.45;

                        return Center(
                          child: Transform.translate(
                            offset: Offset(0, yOffset),
                            child: Transform.scale(
                              scale: scale,
                              child: SizedBox(
                                width: itemWidth,
                                height: constraints.maxHeight * 0.82,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (isSelected) {
                                      final screen = games[index]['screen'] ??
                                          CategorySelectionScreen(gameTitle: games[index]['title'] ?? '');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => screen),
                                      );
                                    } else {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 350),
                                        curve: Curves.easeOutCubic,
                                      );
                                    }
                                  },
                                  child: _buildGameCard(games[index], isSelected),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Action Icons
            Row(
              children: [
                _buildCircularGlassButton(
                  imagePath: 'assets/images/profile_icon.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                const SizedBox(width: 14),
                _buildCircularGlassButton(
                  imagePath: 'assets/images/music_icon.png',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      constraints: const BoxConstraints(
                        maxWidth: double.infinity,
                        minWidth: double.infinity,
                      ),
                      builder: (context) => const MoodBottomSheet(),
                    );
                  },
                ),
                const SizedBox(width: 14),
                _buildCircularGlassButton(
                  imagePath: 'assets/images/help_icon.png',
                  onTap: () {
                    showDialog(context: context, builder: (_) => const VoiceHelpOverlay());
                  },
                ),
              ],
            ),

            // Center Magic Art Badge
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MagicArtScreen()),
                );
              },
              child: AnimatedBuilder(
                animation: _magicGlowController,
                builder: (context, child) {
                  final scale = Tween<double>(begin: 0.92, end: 1.18).transform(
                    Curves.easeInOut.transform(_magicGlowController.value),
                  );
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/src_assets_icons_magic_art.png',
                        height: 72,
                        width: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/magic_image.png',
                          height: 72,
                          width: 72,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Right Badges (My Stuff & Gift Box)
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PortfolioScreen()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/src_assets_icons_my_stuff.png',
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RewardScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/giftbox.png',
                      height: 38,
                      width: 38,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.card_giftcard_rounded,
                        color: Color(0xFFEF5350),
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularGlassButton({
    IconData? icon,
    String? imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: imagePath != null
          ? Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            )
          : Icon(
              icon,
              size: 28,
              color: const Color(0xFF455A64),
            ),
    );
  }

  Widget _buildGameCard(Map<String, dynamic> game, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.20 : 0.08),
            blurRadius: isSelected ? 16 : 6,
            spreadRadius: isSelected ? 1 : 0,
            offset: Offset(0, isSelected ? 8 : 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                game['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 2),
            alignment: Alignment.center,
            child: Text(
              game['title'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.comicNeue(
                fontSize: isSelected ? 17 : 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
