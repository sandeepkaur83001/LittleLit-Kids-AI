import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:get/get.dart';
import 'package:little_kids_ai/features/game/controllers/categories_controller.dart';
import 'package:little_kids_ai/features/game/coloring_drawing_selection_screen.dart';

class ColoringTheme {
  final String title;
  final String coverImage;
  final List<DrawingItem> drawings;
  final bool isSpecial;
  final CategoryModel? category;

  ColoringTheme({
    required this.title,
    required this.coverImage,
    required this.drawings,
    this.isSpecial = false,
    this.category,
  });
}

class ColoringThemeSelectionScreen extends StatefulWidget {
  final CategoryModel? category;
  const ColoringThemeSelectionScreen({super.key, this.category});

  @override
  State<ColoringThemeSelectionScreen> createState() => _ColoringThemeSelectionScreenState();
}

class _ColoringThemeSelectionScreenState extends State<ColoringThemeSelectionScreen> with SingleTickerProviderStateMixin {
  final CategoriesController _categoriesController = Get.find<CategoriesController>();

  late PageController _pageController;
  double _currentPage = 2.0;

  late AnimationController _floatController;

  final List<ColoringTheme> _fallbackThemes = [
    ColoringTheme(
      title: 'Animal Kingdom',
      coverImage: 'assets/images/animal_kingdom.png',
      drawings: [
        DrawingItem(title: 'Lion King', image: 'https://picsum.photos/400/400?random=421'),
        DrawingItem(title: 'Elephant Family', image: 'https://picsum.photos/400/400?random=422'),
      ],
    ),
    ColoringTheme(
      title: 'Birthday',
      coverImage: 'assets/images/birthday.png',
      drawings: [
        DrawingItem(title: 'Birthday Cake', image: 'https://picsum.photos/400/400?random=423'),
      ],
    ),
    ColoringTheme(
      title: 'Boats',
      coverImage: 'assets/images/boats.png',
      drawings: [
        DrawingItem(title: 'Sailboat', image: 'https://picsum.photos/400/400?random=424'),
      ],
    ),
    ColoringTheme(
      title: 'Christmas',
      coverImage: 'assets/images/christmas.png',
      drawings: [
        DrawingItem(title: 'Christmas Tree', image: 'https://picsum.photos/400/400?random=425'),
      ],
    ),
    ColoringTheme(
      title: 'Community Helpers',
      coverImage: 'assets/images/community_helpers.png',
      drawings: [
        DrawingItem(title: 'Firefighter', image: 'https://picsum.photos/400/400?random=426'),
      ],
    ),
    ColoringTheme(
      title: 'Farm',
      coverImage: 'assets/images/farm.png',
      drawings: [
        DrawingItem(title: 'Barn & Tractor', image: 'https://picsum.photos/400/400?random=427'),
      ],
    ),
    ColoringTheme(
      title: 'Fruits & Vegetables',
      coverImage: 'assets/images/fruits_vegetables.png',
      drawings: [
        DrawingItem(title: 'Apple & Pear', image: 'https://picsum.photos/400/400?random=428'),
      ],
    ),
    ColoringTheme(
      title: 'Your theme',
      coverImage: '',
      isSpecial: true,
      drawings: [
        DrawingItem(title: 'Custom Sparkle', image: 'https://picsum.photos/400/400?random=441'),
      ],
    ),
  ];

  CategoryModel? _findParentCategory() {
    if (widget.category != null && widget.category!.children != null && widget.category!.children!.isNotEmpty) {
      return widget.category;
    }
    final serverCategories = _categoriesController.categoryList;
    if (serverCategories.isNotEmpty) {
      return serverCategories.firstWhereOrNull((c) {
        final cName = (c.name ?? '').toLowerCase();
        final cSlug = (c.slug ?? '').toLowerCase();
        return cSlug.contains('color') || cName.contains('color') || (c.id == 77 || c.id == 58);
      });
    }
    return null;
  }

  List<ColoringTheme> _getEffectiveThemes() {
    final parent = _findParentCategory();
    final children = parent?.children;
    if (children != null && children.isNotEmpty) {
      return children.map((c) {
        final isSpecial = (c.slug == 'your-theme' || c.name?.toLowerCase() == 'your theme' || c.isSpecial == true);
        final drawings = (c.children != null && c.children!.isNotEmpty)
            ? c.children!.map((child) => DrawingItem(
                title: child.name ?? '',
                image: child.iconUrl ?? child.icon ?? child.image ?? '',
              )).toList()
            : <DrawingItem>[];
        return ColoringTheme(
          title: c.name ?? '',
          coverImage: c.iconUrl ?? c.icon ?? c.image ?? '',
          isSpecial: isSpecial,
          drawings: drawings,
          category: c,
        );
      }).toList();
    }
    return _fallbackThemes;
  }

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.185,
    );
    _currentPage = 0.0;

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
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onThemeSelected(ColoringTheme theme) {
    final children = theme.category?.children;
    if (children == null || children.isEmpty) {
      CustomToast.showToast(message: 'Coming Soon');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColoringDrawingSelectionScreen(
          themeName: theme.title,
          drawings: theme.drawings,
          category: theme.category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/src_assets_background_creative_back.png',
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

          // Bottom Right Brushie Mascot GIF (Decreased size)
          Positioned(
            bottom: 6,
            right: 18,
            child: Image.asset(
              'assets/images/src_assets_gifs_brushie.gif',
              height: 138,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/src_assets_icons_intro_brushie.png',
                height: 130,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 105,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left Animated Brushie Mascot Image (Increased size)
            Positioned(
              left: 10,
              top: 14,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final double t = _floatController.value;
                  double yOffset = 0.0;

                  if (t < 0.28) {
                    final double p = t / 0.28;
                    yOffset = -10.0 * Curves.easeOutQuad.transform(p);
                  } else if (t < 0.70) {
                    final double p = (t - 0.28) / 0.42;
                    final double verticalShake = math.sin(p * 4 * 2 * math.pi);
                    yOffset = -10.0 + (verticalShake * 3.0);
                  } else if (t < 0.88) {
                    final double p = (t - 0.70) / 0.18;
                    yOffset = -10.0 * (1.0 - Curves.easeInQuad.transform(p));
                  } else {
                    yOffset = 0.0;
                  }

                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/src_assets_icons_intro_brushie.png',
                  height: 82,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),

            // Center Title
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Text(
                  'Pick a theme to begin',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
            ),

            // Right Close Button
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF80CBC4).withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black54, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(ColoringTheme theme, bool isSelected) {
    if (theme.isSpecial) {
      return _buildSpecialThemeCard(theme, isSelected);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.22 : 0.04),
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
              child: _buildCardImage(theme.coverImage),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              theme.title,
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

  Widget _buildSpecialThemeCard(ColoringTheme theme, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.22 : 0.04),
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
              theme.title,
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
      fallbackIcon: Icons.palette_outlined,
    );
  }
}

class _SpeechBubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
