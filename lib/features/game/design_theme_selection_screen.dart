import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class DesignThemeSelectionScreen extends StatefulWidget {
  final String selectedDesignTitle;
  final String? selectedDesignImage;
  final CategoryModel? category;

  const DesignThemeSelectionScreen({
    super.key,
    this.selectedDesignTitle = 'Make a fun card',
    this.selectedDesignImage,
    this.category,
  });

  @override
  State<DesignThemeSelectionScreen> createState() => _DesignThemeSelectionScreenState();
}

class _DesignThemeSelectionScreenState extends State<DesignThemeSelectionScreen> {
  final List<Map<String, dynamic>> _fallbackThemes = [
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

  late List<Map<String, dynamic>> themes;
  late PageController _pageController;
  double _currentPage = 3.0; // Focus on 'Animal Kingdom'

  @override
  void initState() {
    super.initState();
    if (widget.category?.children != null && widget.category!.children!.isNotEmpty) {
      final list = widget.category!.children!.map((c) {
        final isSpecial = (c.slug == 'your-theme' || c.name?.toLowerCase() == 'your idea' || c.name?.toLowerCase() == 'your theme' || c.isSpecial == true);
        return {
          'id': c.id,
          'title': c.name ?? '',
          'image': c.iconUrl ?? c.icon ?? c.image ?? '',
          'isSpecial': isSpecial,
          'model': c,
        };
      }).toList();

      if (!list.any((item) => item['isSpecial'] == true)) {
        final middleIndex = (list.length / 2).floor();
        list.insert(middleIndex, {'title': 'Your theme', 'isSpecial': true});
      }
      themes = list;
    } else {
      themes = _fallbackThemes;
    }

    final initial = (themes.length > 3) ? 3 : 0;
    _currentPage = initial.toDouble();
    const double viewportFraction = 0.185;
    _pageController = PageController(
      initialPage: initial,
      viewportFraction: viewportFraction,
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

  void _onThemeSelected(Map<String, dynamic> theme) {
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
                const SizedBox(height: 35),
              ],
            ),

            // Top-left mini deck showing previous card art & title (Back button)
            Positioned(
              top: 6,
              left: 14,
              child: _buildTopLeftDeckButton(context),
            ),

            // Chameleon mascot in bottom right
            Positioned(
              bottom: 8,
              right: 20,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/chameleon.png',
                  height: 170,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Spacer to account for top-left mini card
          const SizedBox(width: 76),

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
              child: const Icon(Icons.close, color: Colors.black54, size: 24),
            ),
          ),
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
                        child: _buildDesignThumbnail(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.selectedDesignTitle,
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

  Widget _buildDesignThumbnail() {
    if (widget.selectedDesignImage != null && widget.selectedDesignImage!.isNotEmpty) {
      if (widget.selectedDesignImage!.startsWith('http')) {
        return Image.network(
          widget.selectedDesignImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/design_stuff.png',
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Image.asset(
          widget.selectedDesignImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/design_stuff.png',
            fit: BoxFit.cover,
          ),
        );
      }
    }
    return Image.asset(
      'assets/images/design_stuff.png',
      fit: BoxFit.cover,
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
              child: AppCardImage(
                imageUrl: theme['image'],
                fallbackAsset: 'assets/images/design_stuff.png',
                fallbackIcon: Icons.checkroom_outlined,
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
