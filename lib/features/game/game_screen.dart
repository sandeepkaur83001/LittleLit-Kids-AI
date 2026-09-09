import 'dart:math' as math;
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
import 'package:little_kids_ai/features/game/puzzle_theme_selection_screen.dart';
import 'package:little_kids_ai/features/game/design_apparel_selection_screen.dart';
import 'package:little_kids_ai/features/game/build_project_category_selection_screen.dart';
import 'package:little_kids_ai/features/game/voice_help_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _magicGlowController;

  final List<Map<String, dynamic>> games = [
    {'title': 'Make Posters', 'image': 'assets/images/make_posters.png', 'screen': const CategorySelectionScreen(gameTitle: 'Make Posters')},
    {'title': 'Write Storybook', 'image': 'assets/images/write_storybooks.png', 'screen': const BookCreationScreen()},
    {'title': 'Design Puzzles', 'image': 'assets/images/design_puzzels.png', 'screen': const PuzzleThemeSelectionScreen()},
    {'title': 'Design Stuff', 'image': 'assets/images/design_stuff.png', 'screen': const DesignApparelSelectionScreen()},
    {'title': 'Create Songs', 'image': 'assets/images/create_songs.png', 'screen': const TuneSelectionScreen()},
    {'title': 'Coloring Art', 'image': 'assets/images/coloring_arts.png', 'screen': const ColoringThemeSelectionScreen()},
    {'title': 'Build Projects', 'image': 'assets/images/build_projects.png', 'screen': const BuildProjectCategorySelectionScreen()},
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

    const double viewportFraction = 0.185;
    _pageController = PageController(
      initialPage: 2,
      viewportFraction: viewportFraction,
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
                // Always dynamically use _pageController.viewportFraction
                final double fraction = _pageController.viewportFraction;
                final double slotWidth = width * fraction;
                // +1.0 prevents any sub-pixel gap on high-DPI displays
                final double itemWidth = slotWidth + 1.0;
                final double itemHeight = math.min(itemWidth * 1.38, math.min(constraints.maxHeight * 0.80, 280.0));

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

                        // Base scale is 1.0 for all inactive cards (zero gap between cards)
                        // Selected card smoothly scales to 1.18 and pops up
                        final double progress = (1.0 - (pageOffset.abs() * 0.9)).clamp(0.0, 1.0);
                        final double scale = 1.0 + (progress * 0.18);
                        final double yOffset = -16.0 * progress;
                        final bool isSelected = pageOffset.abs() < 0.45;

                        return Center(
                          child: Transform.translate(
                            offset: Offset(0, yOffset),
                            child: Transform.scale(
                              scale: scale,
                              child: SizedBox(
                                width: itemWidth,
                                height: itemHeight,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VoiceHelpScreen()),
                    );
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
                        height: 52,
                        width: 52,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/magic_image.png',
                          height: 52,
                          width: 52,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(14),
                      // border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.2),
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
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.20 : 0.04),
            blurRadius: isSelected ? 18 : 3,
            spreadRadius: isSelected ? 2 : 0,
            offset: Offset(0, isSelected ? 8 : 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                game['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.center,
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
            padding: const EdgeInsets.only(top: 8, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              game['title'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: isSelected ? 15 : 13.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
