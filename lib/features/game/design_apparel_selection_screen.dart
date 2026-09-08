import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/design_studio_screen.dart';

class ApparelItem {
  final String title;
  final Color color;
  final bool isShirt;

  ApparelItem({required this.title, required this.color, this.isShirt = true});
}

class DesignApparelSelectionScreen extends StatefulWidget {
  const DesignApparelSelectionScreen({super.key});

  @override
  State<DesignApparelSelectionScreen> createState() => _DesignApparelSelectionScreenState();
}

class _DesignApparelSelectionScreenState extends State<DesignApparelSelectionScreen> {
  late PageController _pageController;
  double _currentPage = 2.0;

  final List<ApparelItem> _items = [
    ApparelItem(title: 'White T-Shirt', color: Colors.white, isShirt: true),
    ApparelItem(title: 'Red Shorts', color: const Color(0xFFF87171), isShirt: false),
    ApparelItem(title: 'Pink T-Shirt', color: const Color(0xFFF472B6), isShirt: true),
    ApparelItem(title: 'Yellow T-Shirt', color: const Color(0xFFFDE047), isShirt: true),
    ApparelItem(title: 'Sky Blue T-Shirt', color: const Color(0xFF38BDF8), isShirt: true),
    ApparelItem(title: 'Green T-Shirt', color: const Color(0xFF4ADE80), isShirt: true),
    ApparelItem(title: 'Yellow Shorts', color: const Color(0xFFFACC15), isShirt: false),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 3, // Yellow T-Shirt by default
      viewportFraction: 0.22,
    );
    _currentPage = 3.0;

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

  void _onItemSelected(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DesignStudioScreen(
          item: _items[index],
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
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 14),
                Text(
                  'Pick one!',
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 18),

                // Center Apparel Carousel
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final double slotWidth = width * 0.22;
                      final double itemWidth = (slotWidth - 4.0).clamp(160.0, 240.0);

                      return PageView.builder(
                        controller: _pageController,
                        itemCount: _items.length,
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
                              final double yOffset = -20.0 * progress;
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
                                            _onItemSelected(index);
                                          } else {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(milliseconds: 350),
                                              curve: Curves.easeOutCubic,
                                            );
                                          }
                                        },
                                        child: _buildApparelCard(_items[index], isSelected),
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
          ),

          // Bottom Left Chameleon Mascot
          Positioned(
            bottom: 12,
            left: 20,
            child: Image.asset(
              'assets/images/chameleon.png',
              height: 100,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),

          // Bottom Right Home Button
          Positioned(
            bottom: 16,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/images/src_assets_images_game_home.png',
                width: 48,
                height: 48,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF80CBC4).withOpacity(0.85),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Color(0xFF1E293B),
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApparelCard(ApparelItem item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.20 : 0.06),
            blurRadius: isSelected ? 16 : 6,
            offset: Offset(0, isSelected ? 8 : 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          item.isShirt ? Icons.checkroom_rounded : Icons.dry_cleaning_rounded,
          size: 110,
          color: item.color == Colors.white ? const Color(0xFFE2E8F0) : item.color,
        ),
      ),
    );
  }
}
