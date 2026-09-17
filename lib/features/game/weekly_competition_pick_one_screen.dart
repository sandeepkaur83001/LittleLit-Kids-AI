import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class WeeklyCompetitionPickOneScreen extends StatefulWidget {
  const WeeklyCompetitionPickOneScreen({super.key});

  @override
  State<WeeklyCompetitionPickOneScreen> createState() => _WeeklyCompetitionPickOneScreenState();
}

class _WeeklyCompetitionPickOneScreenState extends State<WeeklyCompetitionPickOneScreen> {
  late PageController _pageController;
  double _currentPage = 2.0;

  final List<Map<String, dynamic>> _templates = [
    {
      'title': 'Rainbow Pastel',
      'image': 'https://picsum.photos/400/400?random=111',
      'color': const Color(0xFFFDE8F4),
      'borderColor': const Color(0xFFF472B6),
    },
    {
      'title': 'Golden Glow',
      'image': 'https://picsum.photos/400/400?random=112',
      'color': const Color(0xFFFEF9C3),
      'borderColor': const Color(0xFFFACC15),
    },
    {
      'title': 'Holiday Festive',
      'image': 'https://picsum.photos/400/400?random=113',
      'color': const Color(0xFFDC2626),
      'isSpecialHoliday': true,
    },
    {
      'title': 'Party Balloons',
      'image': 'https://picsum.photos/400/400?random=114',
      'color': const Color(0xFF0284C7),
      'isBalloon': true,
    },
    {
      'title': 'Sunny Cream',
      'image': 'https://picsum.photos/400/400?random=115',
      'color': const Color(0xFFFEF3C7),
    },
    {
      'title': 'Sky Blue',
      'image': 'https://picsum.photos/400/400?random=116',
      'color': const Color(0xFFE0F2FE),
    },
  ];

  @override
  void initState() {
    super.initState();
    const double viewportFraction = 0.185;
    _pageController = PageController(
      initialPage: 2,
      viewportFraction: viewportFraction,
    );
    _currentPage = 2.0;

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

  void _onTemplateSelected(int index) {
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
                        itemCount: _templates.length,
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
                                            _onTemplateSelected(index);
                                          } else {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(milliseconds: 350),
                                              curve: Curves.easeOutCubic,
                                            );
                                          }
                                        },
                                        child: _buildTemplateCard(_templates[index], isSelected),
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

            // Chameleon mascot in bottom left
            Positioned(
              bottom: 8,
              left: 18,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/chameleon.png',
                  height: 155,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Home button in bottom right
            Positioned(
              bottom: 16,
              right: 22,
              child: GestureDetector(
                onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: Image.asset(
                  'assets/images/src_assets_icons_btn_home.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6).withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.home_rounded, color: Colors.white, size: 28),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'Pick one!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF80CBC4).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.black54, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.04),
            blurRadius: isSelected ? 18 : 3,
            spreadRadius: isSelected ? 2 : 0,
            offset: Offset(0, isSelected ? 8 : 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AppCardImage(
          imageUrl: item['image'],
          backgroundColor: item['color'],
          fallbackIcon: Icons.auto_awesome_rounded,
        ),
      ),
    );
  }
}
