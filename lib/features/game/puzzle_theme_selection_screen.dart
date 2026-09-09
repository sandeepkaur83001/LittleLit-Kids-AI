import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/game_play_selection_screen.dart';

class PuzzleThemeSelectionScreen extends StatefulWidget {
  const PuzzleThemeSelectionScreen({super.key});

  @override
  State<PuzzleThemeSelectionScreen> createState() => _PuzzleThemeSelectionScreenState();
}

class _PuzzleThemeSelectionScreenState extends State<PuzzleThemeSelectionScreen> {
  final List<Map<String, dynamic>> themes = [
    {
      'title': 'Boats',
      'image': 'https://picsum.photos/400/400?random=41',
    },
    {
      'title': 'Community Helpers',
      'image': 'https://picsum.photos/400/400?random=42',
    },
    {
      'title': 'Farm',
      'image': 'https://picsum.photos/400/400?random=43',
    },
    {
      'title': 'Animal Kingdom',
      'image': 'https://picsum.photos/400/400?random=44',
    },
    {
      'title': 'Fruits & Vegetables',
      'image': 'https://picsum.photos/400/400?random=45',
    },
    {
      'title': 'Your theme',
      'isSpecial': true,
    },
  ];

  late PageController _pageController;
  double _currentPage = 3.0; // Focus on 'Animal Kingdom'

  @override
  void initState() {
    super.initState();
    const double viewportFraction = 0.185;
    _pageController = PageController(
      initialPage: 3,
      viewportFraction: viewportFraction,
    );

    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? 3.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onThemeSelected(Map<String, dynamic> theme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePlaySelectionScreen(
          selectedThemeTitle: theme['title'] ?? 'Animal Kingdom',
          selectedThemeImage: theme['image'],
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

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: themes.length,
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
                                          _onThemeSelected(themes[index]);
                                        } else {
                                          _pageController.animateToPage(
                                            index,
                                            duration: const Duration(milliseconds: 350),
                                            curve: Curves.easeOutCubic,
                                          );
                                        }
                                      },
                                      child: _buildThemeCard(themes[index], isSelected),
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
              const SizedBox(height: 40),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top-left mini chameleon
          Image.asset(
            'assets/images/chameleon.png',
            height: 60,
            width: 60,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(width: 60),
          ),

          // Center Title
          Expanded(
            child: Text(
              'Pick a theme to begin',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),

          // Close button
          GestureDetector(
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
              child: Image.network(
                theme['image'],
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
