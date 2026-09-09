import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/build_project_item_selection_screen.dart';

class BuildProjectCategorySelectionScreen extends StatefulWidget {
  const BuildProjectCategorySelectionScreen({super.key});

  @override
  State<BuildProjectCategorySelectionScreen> createState() =>
      _BuildProjectCategorySelectionScreenState();
}

class _BuildProjectCategorySelectionScreenState
    extends State<BuildProjectCategorySelectionScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  double _currentPage = 2.0;

  late AnimationController _floatController;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Robotics & Machines',
      'image': 'https://picsum.photos/400/400?random=51',
    },
    {
      'title': 'Science Experiments',
      'image': 'https://picsum.photos/400/400?random=52',
    },
    {
      'title': 'Craft & Play',
      'image': 'https://picsum.photos/400/400?random=53',
    },
    {
      'title': 'Kitchen Lab',
      'image': 'https://picsum.photos/400/400?random=54',
    },
    {
      'title': 'Your Theme',
      'isSpecial': true,
    },
    {
      'title': 'Nature Quest',
      'image': 'https://picsum.photos/400/400?random=55',
    },
    {
      'title': 'Clay & Sculpting',
      'image': 'https://picsum.photos/400/400?random=56',
    },
    {
      'title': 'Puppet Theater',
      'image': 'https://picsum.photos/400/400?random=57',
    },
    {
      'title': 'Space & Rockets',
      'image': 'https://picsum.photos/400/400?random=58',
    },
    {
      'title': 'Wooden Structures',
      'image': 'https://picsum.photos/400/400?random=59',
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

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
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuildProjectItemSelectionScreen(
          categoryTitle: categories[index]['title'] ?? 'Robotics & Machines',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/src_assets_background_litto_back.png',
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

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: categories.length,
                      physics: const BouncingScrollPhysics(),
                      padEnds: true,
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double pageOffset = 0.0;
                            if (_pageController.position.haveDimensions) {
                              pageOffset = (_pageController.page ??
                                      _pageController.initialPage.toDouble()) -
                                  index;
                            } else {
                              pageOffset = (_currentPage - index);
                            }

                            final double progress =
                                (1.0 - (pageOffset.abs() * 0.9)).clamp(0.0, 1.0);
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
                                          _onCategorySelected(index);
                                        } else {
                                          _pageController.animateToPage(
                                            index,
                                            duration:
                                                const Duration(milliseconds: 350),
                                            curve: Curves.easeOutCubic,
                                          );
                                        }
                                      },
                                      child: _buildCategoryCard(
                                          categories[index], isSelected),
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

          // Bottom Right Crafty Mascot
          Positioned(
            bottom: 6,
            right: 18,
            child: Image.asset(
              'assets/images/src_assets_icons_char_carfty.png',
              height: 138,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/crafty.png',
                height: 130,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
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
            // Left Animated Crafty Mascot
            Positioned(
              left: 10,
              top: 14,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final double t = _floatController.value;
                  double yOffset = 0.0;

                  if (t < 0.28) {
                    // Phase 1: Move Up smoothly (0.0 -> 0.28)
                    final double p = t / 0.28;
                    yOffset = -10.0 * Curves.easeOutQuad.transform(p);
                  } else if (t < 0.70) {
                    // Phase 2: Moderate Vertical Shake Up & Down (0.28 -> 0.70)
                    final double p = (t - 0.28) / 0.42;
                    final double verticalShake = math.sin(p * 4 * 2 * math.pi);
                    yOffset = -10.0 + (verticalShake * 3.0);
                  } else if (t < 0.88) {
                    // Phase 3: Move Down back to baseline (0.70 -> 0.88)
                    final double p = (t - 0.70) / 0.18;
                    yOffset = -10.0 * (1.0 - Curves.easeInQuad.transform(p));
                  } else {
                    // Phase 4: Settle at baseline (0.88 -> 1.0)
                    yOffset = 0.0;
                  }

                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/src_assets_icons_intro_crafty.png',
                  height: 82,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/crafty.png',
                    height: 82,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              ),
            ),

            // Center Title
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Text(
                  'What kind of project should we build today?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 23,
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

  Widget _buildCategoryCard(Map<String, dynamic> category, bool isSelected) {
    if (category['isSpecial'] == true) {
      return _buildSpecialCard(category, isSelected);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.04),
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
              child: Image.network(
                category['image'],
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
            padding: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              category['title'],
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

  Widget _buildSpecialCard(Map<String, dynamic> category, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.04),
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
              category['title'],
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
