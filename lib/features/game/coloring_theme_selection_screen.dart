import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/coloring_drawing_selection_screen.dart';

class ColoringTheme {
  final String title;
  final String coverImage;
  final List<DrawingItem> drawings;

  ColoringTheme({
    required this.title,
    required this.coverImage,
    required this.drawings,
  });
}

class ColoringThemeSelectionScreen extends StatefulWidget {
  const ColoringThemeSelectionScreen({super.key});

  @override
  State<ColoringThemeSelectionScreen> createState() => _ColoringThemeSelectionScreenState();
}

class _ColoringThemeSelectionScreenState extends State<ColoringThemeSelectionScreen> {
  late PageController _pageController;
  double _currentPage = 2.0;

  final List<ColoringTheme> _themes = [
    ColoringTheme(
      title: 'Holidays',
      coverImage: 'assets/images/coloring_arts.png',
      drawings: [
        DrawingItem(title: 'Gingerbread Man', image: 'assets/images/src_assets_images_photo_frame.png'),
        DrawingItem(title: 'Santa Elf', image: 'assets/images/src_assets_images_photo_frame.png'),
        DrawingItem(title: 'Heart Candies', image: 'assets/images/src_assets_images_photo_frame.png'),
        DrawingItem(title: 'Gift Kitty', image: 'assets/images/src_assets_images_photo_frame.png'),
      ],
    ),
    ColoringTheme(
      title: 'Magic',
      coverImage: 'assets/images/magic_image.png',
      drawings: [
        DrawingItem(title: 'Wizard Girl', image: 'assets/images/coloring_arts.png'),
        DrawingItem(title: 'Baby Dragon', image: 'assets/images/litto.png'),
        DrawingItem(title: 'Magic Wand', image: 'assets/images/magic_image.png'),
        DrawingItem(title: 'Chameleon', image: 'assets/images/chameleon.png'),
      ],
    ),
    ColoringTheme(
      title: 'Ocean',
      coverImage: 'assets/images/create_songs.png',
      drawings: [
        DrawingItem(title: 'Submarine', image: 'assets/images/create_songs.png'),
        DrawingItem(title: 'Cruise Ship', image: 'assets/images/create_songs.png'),
        DrawingItem(title: 'Sailboat', image: 'assets/images/create_songs.png'),
        DrawingItem(title: 'Pirate Boat', image: 'assets/images/create_songs.png'),
      ],
    ),
    ColoringTheme(
      title: 'Royal',
      coverImage: 'assets/images/design_stuff.png',
      drawings: [
        DrawingItem(title: 'Royal Castle', image: 'assets/images/design_stuff.png'),
        DrawingItem(title: 'Princess Crown', image: 'assets/images/design_stuff.png'),
        DrawingItem(title: 'Brave Knight', image: 'assets/images/design_stuff.png'),
      ],
    ),
    ColoringTheme(
      title: 'Vehicles',
      coverImage: 'assets/images/build_projects.png',
      drawings: [
        DrawingItem(title: 'Dump Truck', image: 'assets/images/build_projects.png'),
        DrawingItem(title: 'Bulldozer', image: 'assets/images/build_projects.png'),
        DrawingItem(title: 'Police Car', image: 'assets/images/build_projects.png'),
        DrawingItem(title: 'Ambulance', image: 'assets/images/build_projects.png'),
      ],
    ),
    ColoringTheme(
      title: 'Fruits & Food',
      coverImage: 'assets/images/src_assets_images_apple.png',
      drawings: [
        DrawingItem(title: 'Apple', image: 'assets/images/src_assets_images_apple.png'),
        DrawingItem(title: 'Watermelon Slice', image: 'assets/images/src_assets_images_apple.png'),
        DrawingItem(title: 'Fruit Bowl', image: 'assets/images/src_assets_images_apple.png'),
        DrawingItem(title: 'Bunny Rabbit', image: 'assets/images/src_assets_images_apple.png'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 2,
      viewportFraction: 0.22,
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

  void _onThemeSelected(ColoringTheme theme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColoringDrawingSelectionScreen(
          themeName: theme.title,
          drawings: theme.drawings,
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
                const SizedBox(height: 16),
                // Header Title
                Text(
                  'Pick a theme to begin',
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 24),

                // Theme Carousel
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final double slotWidth = width * 0.22;
                      final double itemWidth = (slotWidth - 4.0).clamp(160.0, 240.0);

                      return PageView.builder(
                        controller: _pageController,
                        itemCount: _themes.length,
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
                                            _onThemeSelected(_themes[index]);
                                          } else {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(milliseconds: 350),
                                              curve: Curves.easeOutCubic,
                                            );
                                          }
                                        },
                                        child: _buildThemeCard(_themes[index], isSelected),
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
                const SizedBox(height: 36),
              ],
            ),
          ),

          // Top Left Back Button
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E78C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(ColoringTheme theme, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF90CAF9) : Colors.white.withOpacity(0.8),
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.08),
            blurRadius: isSelected ? 16 : 6,
            spreadRadius: isSelected ? 1 : 0,
            offset: Offset(0, isSelected ? 8 : 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                theme.coverImage,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.palette_rounded, size: 40, color: Colors.blue),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: Text(
              theme.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.comicNeue(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
