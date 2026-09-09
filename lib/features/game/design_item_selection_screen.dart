import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class DesignItemSelectionScreen extends StatefulWidget {
  final String apparelTitle;

  const DesignItemSelectionScreen({
    super.key,
    required this.apparelTitle,
  });

  @override
  State<DesignItemSelectionScreen> createState() => _DesignItemSelectionScreenState();
}

class _DesignItemSelectionScreenState extends State<DesignItemSelectionScreen> {
  late PageController _pageController;
  double _currentPage = 2.0;

  late List<Map<String, dynamic>> _designItems;

  final Map<String, List<Map<String, dynamic>>> _categoryDesigns = {
    'T-Shirts': [
      {'title': 'Space Astronaut', 'image': 'https://picsum.photos/400/400?random=301'},
      {'title': 'Neon Dinosaur', 'image': 'https://picsum.photos/400/400?random=302'},
      {'title': 'Create Custom', 'isSpecial': true},
      {'title': 'Rainbow Splash', 'image': 'https://picsum.photos/400/400?random=303'},
      {'title': 'Cyber Robot', 'image': 'https://picsum.photos/400/400?random=304'},
      {'title': 'Ocean Dolphin', 'image': 'https://picsum.photos/400/400?random=305'},
    ],
    'Shorts': [
      {'title': 'Summer Palms', 'image': 'https://picsum.photos/400/400?random=311'},
      {'title': 'Cheetah Stripes', 'image': 'https://picsum.photos/400/400?random=312'},
      {'title': 'Create Custom', 'isSpecial': true},
      {'title': 'Galaxy Stars', 'image': 'https://picsum.photos/400/400?random=313'},
      {'title': 'Fire Flames', 'image': 'https://picsum.photos/400/400?random=314'},
    ],
    'Hoodies': [
      {'title': 'Urban Street', 'image': 'https://picsum.photos/400/400?random=321'},
      {'title': 'Cosmic Nebula', 'image': 'https://picsum.photos/400/400?random=322'},
      {'title': 'Create Custom', 'isSpecial': true},
      {'title': 'Pixel Art Hero', 'image': 'https://picsum.photos/400/400?random=323'},
      {'title': 'Winter Blizzard', 'image': 'https://picsum.photos/400/400?random=324'},
    ],
    'Caps': [
      {'title': 'Retro Snapback', 'image': 'https://picsum.photos/400/400?random=331'},
      {'title': 'Graffiti Tag', 'image': 'https://picsum.photos/400/400?random=332'},
      {'title': 'Create Custom', 'isSpecial': true},
      {'title': 'Golden Crown', 'image': 'https://picsum.photos/400/400?random=333'},
      {'title': 'Lightning Bolt', 'image': 'https://picsum.photos/400/400?random=334'},
    ],
    'Sneakers': [
      {'title': 'High-Top Runner', 'image': 'https://picsum.photos/400/400?random=341'},
      {'title': 'Glow in Dark', 'image': 'https://picsum.photos/400/400?random=342'},
      {'title': 'Create Custom', 'isSpecial': true},
      {'title': 'Sonic Waves', 'image': 'https://picsum.photos/400/400?random=343'},
      {'title': 'Dragon Scale', 'image': 'https://picsum.photos/400/400?random=344'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _designItems = _categoryDesigns[widget.apparelTitle] ?? [
      {'title': 'Space Astronaut', 'image': 'https://picsum.photos/400/400?random=301'},
      {'title': 'Neon Dinosaur', 'image': 'https://picsum.photos/400/400?random=302'},
      {'title': 'Create Custom', 'isSpecial': true},
      {'title': 'Rainbow Splash', 'image': 'https://picsum.photos/400/400?random=303'},
      {'title': 'Cyber Robot', 'image': 'https://picsum.photos/400/400?random=304'},
    ];

    final initial = (_designItems.length / 2).floor();
    _currentPage = initial.toDouble();
    _pageController = PageController(
      initialPage: initial,
      viewportFraction: 0.185,
    );

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

  void _onCardTapped(int index) {
    if ((_currentPage - index).abs() < 0.45) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
      );
    } else {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
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
                      itemCount: _designItems.length,
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
                                      onTap: () => _onCardTapped(index),
                                      child: _buildCard(_designItems[index], isSelected),
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'Pick a style for your ${widget.apparelTitle}!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
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
    );
  }

  Widget _buildCard(Map<String, dynamic> item, bool isSelected) {
    if (item['isSpecial'] == true) {
      return _buildSpecialCard(item, isSelected);
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
              child: Image.network(
                item['image'] ?? 'https://picsum.photos/400/400',
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
              item['title'] ?? '',
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

  Widget _buildSpecialCard(Map<String, dynamic> item, bool isSelected) {
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
              item['title'] ?? 'Create Custom',
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
