import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class GamePlaySelectionScreen extends StatefulWidget {
  final String selectedThemeTitle;
  final String? selectedThemeImage;

  const GamePlaySelectionScreen({
    super.key,
    this.selectedThemeTitle = 'Animal Kingdom',
    this.selectedThemeImage,
  });

  @override
  State<GamePlaySelectionScreen> createState() => _GamePlaySelectionScreenState();
}

class _GamePlaySelectionScreenState extends State<GamePlaySelectionScreen> {
  final List<Map<String, dynamic>> _gameCards = const [
    {
      'title': 'MatchIt',
      'asset': 'assets/images/src_assets_icons_g_match_it.png',
    },
    {
      'title': 'SpotnPop',
      'asset': 'assets/images/src_assets_icons_g_spotnpop.png',
    },
    {
      'title': 'Puzzelo',
      'asset': 'assets/images/src_assets_icons_g_puzzelo.png',
    },
    {
      'title': 'Word Shuffle',
      'asset': 'assets/images/src_assets_icons_g_word_shuffle.png',
    },
  ];

  late PageController _pageController;
  double _currentPage = 2.0; // Focus on 'Puzzelo' by default

  @override
  void initState() {
    super.initState();
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
    _pageController.dispose();
    super.dispose();
  }

  void _onCardTapped(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SubscriptionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Header Row
                _buildTopBar(context),
                const SizedBox(height: 8),

                // Center Cards Carousel (Zero-gap continuous card deck)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final double fraction = _pageController.viewportFraction;
                      final double slotWidth = width * fraction;
                      final double itemWidth = slotWidth + 1.0;
                      final double itemHeight = math.min(itemWidth * 1.40, math.min(constraints.maxHeight * 0.82, 280.0));

                      return PageView.builder(
                        controller: _pageController,
                        itemCount: _gameCards.length,
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
                                            _onCardTapped(index);
                                          } else {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(milliseconds: 350),
                                              curve: Curves.easeOutCubic,
                                            );
                                          }
                                        },
                                        child: Image.asset(
                                          _gameCards[index]['asset'],
                                          fit: BoxFit.fill,
                                        ),
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
                const SizedBox(height: 24),
              ],
            ),

            // Top-Left Stacked Mini Card (back button with previous card text & art)
            Positioned(
              top: 6,
              left: 14,
              child: _buildTopLeftDeckButton(context),
            ),

            // Top-Right Home Button
            Positioned(
              top: 10,
              right: 18,
              child: GestureDetector(
                onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: Image.asset(
                  'assets/images/src_assets_icons_btn_home.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6).withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.home_rounded, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),

            // Bottom-Right Mascot (Gamester Puzzle Mascot)
            Positioned(
              bottom: 8,
              right: 16,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/src_assets_icons_char_gamester.png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Spacer for top-left mini card
          const SizedBox(width: 80),

          // Center Title
          Expanded(
            child: Text(
              'What would you like to play today?',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),

          // Spacer for home button
          const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildTopLeftDeckButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 72,
        height: 94,
        color: Colors.transparent,
        child: Stack(
          children: [
            // Layer 1 (bottom layer)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
            // Layer 2 (middle layer)
            Positioned(
              left: 3,
              top: 2,
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Layer 3 (top card)
            Positioned(
              left: 6,
              top: 4,
              child: Container(
                width: 60,
                height: 80,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: _buildThemeThumbnail(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.selectedThemeTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 7.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeThumbnail() {
    if (widget.selectedThemeImage != null && widget.selectedThemeImage!.isNotEmpty) {
      if (widget.selectedThemeImage!.startsWith('http')) {
        return Image.network(
          widget.selectedThemeImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/coloring_arts.png',
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Image.asset(
          widget.selectedThemeImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/coloring_arts.png',
            fit: BoxFit.cover,
          ),
        );
      }
    }
    return Image.asset(
      'assets/images/coloring_arts.png',
      fit: BoxFit.cover,
    );
  }
}
