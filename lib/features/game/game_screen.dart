import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/settings_screen.dart';
import 'package:little_kids_ai/features/game/tune_selection_screen.dart';
import 'package:little_kids_ai/features/game/book_creation_screen.dart';
import 'package:little_kids_ai/features/game/widgets/competition_overlay.dart';
import 'package:little_kids_ai/features/game/widgets/mood_bottom_sheet.dart';
import 'package:little_kids_ai/features/game/reward_screen.dart';
import 'package:little_kids_ai/features/game/category_selection_screen.dart';
import 'package:little_kids_ai/features/game/portfolio_screen.dart';
import 'package:little_kids_ai/features/game/magic_art_screen.dart';
import 'package:little_kids_ai/features/game/coloring_theme_selection_screen.dart';
import 'package:little_kids_ai/features/game/puzzle_theme_selection_screen.dart';
import 'package:little_kids_ai/features/game/design_apparel_selection_screen.dart';
import 'package:little_kids_ai/features/game/build_project_category_selection_screen.dart';
import 'package:get/get.dart';
import 'package:little_kids_ai/features/game/controllers/categories_controller.dart';
import 'package:little_kids_ai/features/game/voice_help_screen.dart';

import 'package:little_kids_ai/features/game/controllers/friends_controller.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _magicGlowController;
  final CategoriesController _categoriesController = Get.find<CategoriesController>();
  final FriendsController _friendsController = Get.find<FriendsController>();

  final List<Map<String, dynamic>> _fallbackGames = [
    {'title': 'Make Posters', 'slug': 'make-posters', 'image': 'assets/images/make_posters.png', 'fallbackAsset': 'assets/images/make_posters.png'},
    {'title': 'Write Storybooks', 'slug': 'write-storybooks', 'image': 'assets/images/write_storybooks.png', 'fallbackAsset': 'assets/images/write_storybooks.png'},
    {'title': 'Design Puzzles', 'slug': 'design-puzzles', 'image': 'assets/images/design_puzzels.png', 'fallbackAsset': 'assets/images/design_puzzels.png'},
    {'title': 'Design Stuff', 'slug': 'design-stuff', 'image': 'assets/images/design_stuff.png', 'fallbackAsset': 'assets/images/design_stuff.png'},
    {'title': 'Create Songs', 'slug': 'create-songs', 'image': 'assets/images/create_songs.png', 'fallbackAsset': 'assets/images/create_songs.png'},
    {'title': 'Coloring Art', 'slug': 'coloring-art', 'image': 'assets/images/coloring_arts.png', 'fallbackAsset': 'assets/images/coloring_arts.png'},
    {'title': 'Build Projects', 'slug': 'build-projects', 'image': 'assets/images/build_projects.png', 'fallbackAsset': 'assets/images/build_projects.png'},
  ];

  late PageController _pageController;
  double _currentPage = 2.0;

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

    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) {
      if (_categoriesController.categoryList.isEmpty) {
        _categoriesController.fetchCategories();
      }
      _friendsController.fetchPendingRequests();
    }

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

  String _getFallbackAsset(String? slug, String? title) {
    final s = (slug ?? title ?? '').toLowerCase().replaceAll(' ', '-').replaceAll('_', '-');
    if (s.contains('poster')) return 'assets/images/make_posters.png';
    if (s.contains('storybook') || s.contains('story') || s.contains('write')) return 'assets/images/write_storybooks.png';
    if (s.contains('puzzle')) return 'assets/images/design_puzzels.png';
    if (s.contains('stuff')) return 'assets/images/design_stuff.png';
    if (s.contains('song') || s.contains('tune') || s.contains('music')) return 'assets/images/create_songs.png';
    if (s.contains('color')) return 'assets/images/coloring_arts.png';
    if (s.contains('project') || s.contains('build')) return 'assets/images/build_projects.png';
    return 'assets/images/make_posters.png';
  }

  List<Map<String, dynamic>> _getEffectiveGames() {
    final _ = _categoriesController.categoryList.length;
    final serverCategories = _categoriesController.categoryList;
    if (serverCategories.isNotEmpty) {
      return serverCategories.map((cat) {
        return {
          'id': cat.id,
          'title': cat.name ?? '',
          'slug': cat.slug ?? '',
          'image': cat.iconUrl ?? cat.icon ?? '',
          'fallbackAsset': _getFallbackAsset(cat.slug, cat.name),
          'category': cat,
        };
      }).toList();
    }
    return _fallbackGames;
  }

  void _onCategorySelected(Map<String, dynamic> game) {
    CategoryModel? cat = game['category'] as CategoryModel?;
    final title = (game['title'] as String?) ?? '';
    final slug = (game['slug'] as String? ?? title).toLowerCase();

    if (cat == null || cat.children == null || cat.children!.isEmpty) {
      final serverCategories = _categoriesController.categoryList;
      if (serverCategories.isNotEmpty) {
        cat = serverCategories.firstWhereOrNull((c) {
          final cSlug = (c.slug ?? '').toLowerCase();
          final cName = (c.name ?? '').toLowerCase();
          return cSlug == slug || cName == title.toLowerCase() || (game['id'] != null && c.id == game['id']);
        });
      }
    }

    Widget destinationScreen;
    if (slug.contains('poster')) {
      destinationScreen = CategorySelectionScreen(gameTitle: title.isNotEmpty ? title : 'Make Posters', category: cat);
    } else if (slug.contains('storybook') || slug.contains('story') || slug.contains('write')) {
      destinationScreen = BookCreationScreen(category: cat);
    } else if (slug.contains('puzzle')) {
      destinationScreen = PuzzleThemeSelectionScreen(category: cat);
    } else if (slug.contains('stuff')) {
      destinationScreen = DesignApparelSelectionScreen(category: cat);
    } else if (slug.contains('song') || slug.contains('tune') || slug.contains('music')) {
      destinationScreen = TuneSelectionScreen(category: cat);
    } else if (slug.contains('color')) {
      destinationScreen = ColoringThemeSelectionScreen(category: cat);
    } else if (slug.contains('build') || slug.contains('project')) {
      destinationScreen = BuildProjectCategorySelectionScreen(category: cat);
    } else {
      destinationScreen = CategorySelectionScreen(gameTitle: title, category: cat);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destinationScreen),
    );
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
                final double fraction = _pageController.viewportFraction;
                final double slotWidth = width * fraction;
                final double itemWidth = slotWidth + 1.0;
                final double itemHeight = math.min(itemWidth * 1.38, math.min(constraints.maxHeight * 0.80, 280.0));

                return Obx(() {
                  final games = _getEffectiveGames();

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
                                        _onCategorySelected(games[index]);
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
                });
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
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        'assets/images/src_assets_icons_my_stuff.png',
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                      Obx(() {
                        final count = _friendsController.pendingRequests.length;
                        if (count == 0) return const SizedBox.shrink();
                        return Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
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
    final String? imageUrl = game['image'];
    final String? fallbackAsset = game['fallbackAsset'];

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
              child: _buildCardImage(imageUrl, fallbackAsset),
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

  Widget _buildCardImage(String? imageUrl, String? fallbackAsset) {
    return AppCardImage(
      imageUrl: imageUrl,
      fallbackAsset: fallbackAsset,
      fallbackIcon: Icons.videogame_asset_outlined,
    );
  }
}
