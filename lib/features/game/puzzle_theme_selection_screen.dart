import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:get/get.dart';
import 'package:little_kids_ai/features/game/controllers/categories_controller.dart';
import 'package:little_kids_ai/features/game/game_play_selection_screen.dart';

class PuzzleThemeSelectionScreen extends StatefulWidget {
  final CategoryModel? category;
  const PuzzleThemeSelectionScreen({super.key, this.category});

  @override
  State<PuzzleThemeSelectionScreen> createState() => _PuzzleThemeSelectionScreenState();
}

class _PuzzleThemeSelectionScreenState extends State<PuzzleThemeSelectionScreen> {
  final CategoriesController _categoriesController = Get.find<CategoriesController>();

  final List<Map<String, dynamic>> _fallbackThemes = [
    {
      'title': 'Animal Kingdom',
      'image': 'assets/images/animal_kingdom.png',
    },
    {
      'title': 'Birthday',
      'image': 'assets/images/birthday.png',
    },
    {
      'title': 'Boats',
      'image': 'assets/images/boats.png',
    },
    {
      'title': 'Christmas',
      'image': 'assets/images/christmas.png',
    },
    {
      'title': 'Community Helpers',
      'image': 'assets/images/community_helpers.png',
    },
    {
      'title': 'Farm',
      'image': 'assets/images/farm.png',
    },
    {
      'title': 'Fruits & Vegetables',
      'image': 'assets/images/fruits_vegetables.png',
    },
    {
      'title': 'Your theme',
      'isSpecial': true,
    },
  ];

  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty && _categoriesController.categoryList.isEmpty) {
      _categoriesController.fetchCategories();
    }
    const double viewportFraction = 0.185;
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: viewportFraction,
    );

    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  CategoryModel? _findParentCategory() {
    if (widget.category != null && widget.category!.children != null && widget.category!.children!.isNotEmpty) {
      return widget.category;
    }
    final serverCategories = _categoriesController.categoryList;
    if (serverCategories.isNotEmpty) {
      return serverCategories.firstWhereOrNull((c) {
        final cName = (c.name ?? '').toLowerCase();
        final cSlug = (c.slug ?? '').toLowerCase();
        return cSlug.contains('puzzle') || cName.contains('puzzle') || (c.id == 24 || c.id == 15);
      });
    }
    return null;
  }

  List<Map<String, dynamic>> _getEffectiveThemes() {
    final parent = _findParentCategory();
    final children = parent?.children;
    if (children != null && children.isNotEmpty) {
      final sharedChildren = children.firstWhereOrNull((c) => c.children != null && c.children!.isNotEmpty)?.children;

      return children.map((c) {
        final isSpecial = (c.slug == 'your-theme' || c.name?.toLowerCase() == 'your theme' || c.isSpecial == true);
        if ((c.children == null || c.children!.isEmpty) && sharedChildren != null && sharedChildren.isNotEmpty) {
          c.children = sharedChildren;
        }
        return {
          'id': c.id,
          'title': c.name ?? '',
          'image': c.iconUrl ?? c.icon ?? c.image ?? '',
          'isSpecial': isSpecial,
          'model': c,
        };
      }).toList();
    }
    return _fallbackThemes;
  }

  void _onThemeSelected(Map<String, dynamic> theme) {
    final model = theme['model'] as CategoryModel?;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePlaySelectionScreen(
          selectedThemeTitle: theme['title'] ?? 'Boats',
          selectedThemeImage: theme['image'],
          category: model,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    final double fraction = _pageController.viewportFraction;
                    final double slotWidth = width * fraction;
                    final double itemWidth = slotWidth + 1.0;
                    final double itemHeight = math.min(itemWidth * 1.38, math.min(constraints.maxHeight * 0.80, 280.0));

                    final effectiveThemes = _getEffectiveThemes();

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: effectiveThemes.length,
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
                                          _onThemeSelected(effectiveThemes[index]);
                                        } else {
                                          _pageController.animateToPage(
                                            index,
                                            duration: const Duration(milliseconds: 350),
                                            curve: Curves.easeOutCubic,
                                          );
                                        }
                                      },
                                      child: _buildThemeCard(effectiveThemes[index], isSelected),
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
              const SizedBox(height: 35),
            ],
          ),

          // Chameleon mascot in bottom right
          Positioned(
            bottom: 10,
            right: 24,
            child: Image.asset(
              'assets/images/chameleon.png',
              height: 190,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Title Text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'Pick your favorite theme to start solving puzzles!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF80CBC4).withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.black54, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(Map<String, dynamic> theme, bool isSelected) {
    if (theme['isSpecial'] == true) {
      return _buildSpecialCard(theme, isSelected);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
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
              child: _buildCardImage(theme['image']),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              theme['title'] ?? '',
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

  Widget _buildCardImage(String? imagePath) {
    return AppCardImage(
      imageUrl: imagePath,
      fallbackIcon: Icons.extension_outlined,
    );
  }

  Widget _buildSpecialCard(Map<String, dynamic> theme, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
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
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF95DBAC),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Type or Talk...',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD54F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mic, color: Colors.white, size: 28),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward, color: Color(0xFF95DBAC), size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              theme['title'],
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
