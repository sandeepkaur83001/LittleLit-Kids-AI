import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

import 'package:little_kids_ai/features/game/coloring_art_screen.dart';

class DrawingItem {
  final String title;
  final String image;
  final bool isFree;

  DrawingItem({required this.title, required this.image, this.isFree = false});
}

class ColoringDrawingSelectionScreen extends StatefulWidget {
  final String themeName;
  final List<DrawingItem> drawings;

  const ColoringDrawingSelectionScreen({
    super.key,
    required this.themeName,
    required this.drawings,
  });

  @override
  State<ColoringDrawingSelectionScreen> createState() => _ColoringDrawingSelectionScreenState();
}

class _ColoringDrawingSelectionScreenState extends State<ColoringDrawingSelectionScreen> {
  late PageController _pageController;
  double _currentPage = 2.0;

  @override
  void initState() {
    super.initState();
    final initial = (widget.drawings.length / 2).floor();
    _pageController = PageController(
      initialPage: initial,
      viewportFraction: 0.22,
    );
    _currentPage = initial.toDouble();

    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? initial.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDrawingSelected(int index) {
    final item = widget.drawings[index];
    // Free plan: Daily one game free (first card is free, others prompt subscription)
    if (index == 0 || item.isFree) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ColoringArtScreen(
            templateImage: item.image,
            templateTitle: item.title,
          ),
        ),
      );
    } else {
      // Show Subscription UI matching reference screenshot
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 14),
                // Top Header Text (2 Lines)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        'Ready to make magic? Choose a drawing to color and',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'watch the character or object come to life!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Center Drawing Outlines Carousel
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final double slotWidth = width * 0.22;
                      final double itemWidth = (slotWidth - 4.0).clamp(160.0, 240.0);

                      return PageView.builder(
                        controller: _pageController,
                        itemCount: widget.drawings.length,
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

                              final double progress = (1.0 - (pageOffset.abs() * 0.85)).clamp(0.0, 1.0);
                              final double scale = 0.88 + (progress * 0.22);
                              final double yOffset = -18.0 * progress;
                              final bool isSelected = pageOffset.abs() < 0.45;

                              return Center(
                                child: Transform.translate(
                                  offset: Offset(0, yOffset),
                                  child: Transform.scale(
                                    scale: scale,
                                    child: SizedBox(
                                      width: itemWidth,
                                      height: 280,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          if (isSelected) {
                                            _onDrawingSelected(index);
                                          } else {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(milliseconds: 350),
                                              curve: Curves.easeOutCubic,
                                            );
                                          }
                                        },
                                        child: _buildOutlineCard(widget.drawings[index], isSelected),
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
                const SizedBox(height: 50),
              ],
            ),
          ),

          // Bottom Left Brushie Mascot
          Positioned(
            bottom: 8,
            left: 20,
            child: Image.asset(
              'assets/images/src_assets_gifs_brushie.gif',
              height: 110,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/src_assets_icons_intro_brushie.png',
                height: 110,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),

          // Bottom Right Home / Back Button
          Positioned(
            bottom: 16,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF80CBC4).withOpacity(0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Color(0xFF1E293B),
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineCard(DrawingItem item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF90CAF9) : Colors.white.withOpacity(0.9),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.08),
            blurRadius: isSelected ? 18 : 6,
            spreadRadius: isSelected ? 1 : 0,
            offset: Offset(0, isSelected ? 8 : 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          item.image,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.palette_outlined, size: 48, color: Colors.blueGrey),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: GoogleFonts.comicNeue(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
