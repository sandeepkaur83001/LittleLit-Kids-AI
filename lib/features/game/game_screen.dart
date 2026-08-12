import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/settings_screen.dart';
import 'package:little_kids_ai/features/game/tune_selection_screen.dart';
import 'package:little_kids_ai/features/game/book_creation_screen.dart';
import 'package:little_kids_ai/features/game/widgets/voice_help_overlay.dart';
import 'package:little_kids_ai/features/game/widgets/competition_overlay.dart';
import 'package:little_kids_ai/features/game/reward_screen.dart';
import 'package:little_kids_ai/features/game/category_selection_screen.dart';
import 'package:little_kids_ai/features/game/portfolio_screen.dart';
import 'package:little_kids_ai/features/game/magic_art_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _musicIconController;
  final List<Map<String, dynamic>> games = [
    {'title': 'Make Posters', 'image': 'assets/images/make_posters.png'},
    {'title': 'Design Stuff', 'image': 'assets/images/design_stuff.png'},
    {'title': 'Write Storybooks', 'image': 'assets/images/write_storybooks.png', 'screen': const BookCreationScreen()},
    {'title': 'Design Puzzles', 'image': 'assets/images/design_puzzels.png'},
    {'title': 'Design Stuff', 'image': 'assets/images/design_stuff.png'},

    {'title': 'Create Songs', 'image': 'assets/images/create_songs.png', 'screen': const TuneSelectionScreen()},
    {'title': 'Coloring Art', 'image': 'assets/images/coloring_arts.png'},
    {'title': 'Build Projects', 'image': 'assets/images/build_projects.png'},
    {'title': 'Design Stuff', 'image': 'assets/images/design_stuff.png'},
    {'title': 'Design Stuff', 'image': 'assets/images/design_stuff.png'},
  ];

  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.1, // Slot size for each item (15% of width)
  );
  double _currentPage = 1.0;

  @override
  void initState() {
    super.initState();
    _musicIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    // _loadGameData(); // API Call: Fetching available games from server
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? 1.0;
        });
      }
    });

    // Show competition overlay on redirect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CompetitionOverlay(),
      );
    });
  }

  @override
  void dispose() {
    _musicIconController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: "assets/images/landscape_background_clean.png",
      child: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double itemWidth = width * 0.18; // Visual card width (25% of screen)

                // Sort indices based on distance from _currentPage to control Z-index
                // Cards further away are drawn first (bottom), center card is drawn last (top)
                List<int> indices = List.generate(games.length, (i) => i);
                indices.sort((a, b) => (b - _currentPage).abs().compareTo((a - _currentPage).abs()));

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Render cards in sorted order
                    ...indices.map((index) {
                      double diff = (index - _currentPage);

                      // Calculate horizontal position
                      // MUST match viewportFraction for intuitive hit testing and smooth motion
                      double xOffset = diff * (width * 0.15);

                      // Pop effect logic (scaling)
                      double value = (1 - (diff.abs() * 0.8)).clamp(0.0, 1.0);
                      double scale = 0.85 + (value * 0.22);

                      return Transform.translate(
                        offset: Offset(xOffset, 0),
                        child: Transform.scale(
                          scale: scale,
                          child: SizedBox(
                            width: itemWidth,
                            height: 250,
                            child: _buildGameCard(games[index], value > 0.8),
                          ),
                        ),
                      );
                    }),
                    // Invisible PageView on top to capture swipe gestures and handle taps
                    Positioned.fill(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: games.length,
                        padEnds: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if ((index - _currentPage).abs() < 0.5) {
                                final screen = games[index]['screen'] ??
                                    CategorySelectionScreen(gameTitle: games[index]['title'] ?? '');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => screen),
                                );
                              } else {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Container(
                              color: Colors.transparent, // Ensures it's hit-testable
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left icons
            Row(
              children: [
                _buildRoundIcon('assets/images/person-svg.svg', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                }),
                const SizedBox(width: 10),
                _buildRoundIcon('assets/images/music-svg.svg', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TuneSelectionScreen()),
                  );
                }),
                const SizedBox(width: 10),
                _buildRoundIcon('assets/images/help-svg.svg', onTap: () {
                  showDialog(context: context, builder: (_) => const VoiceHelpOverlay());
                }),
              ],
            ),
            // Center logo
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MagicArtScreen()),
                );
              },
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.5).animate(
                  CurvedAnimation(parent: _musicIconController, curve: Curves.easeInOut),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration:  BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/magic_image.png',
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
            ),
            // Right icons
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PortfolioScreen()),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background Box
                      Container(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 12,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD).withOpacity(0.7), // Soft translucent blue
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My',
                              style: TextStyle(
                                fontSize: 16,
          fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'Stuff',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
      
                      // Overlapping Yellow Star Icon
                      const Positioned(
                        left: -18,
                        top: -12,
                        child: Icon(
                          Icons.star_rounded,
                          size: 48,
                          color: Color(0xFFFFB800), // Bright yellow/gold
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RewardScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD).withOpacity(0.7), // Soft translucent blue
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/giftbox.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundIcon(String svgPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: SvgPicture.asset(
          svgPath,
          height: 40,
          width: 40,
        ),
      ),
    );
  }

  Widget _buildGameCard(Map<String, dynamic> game, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.08),
            blurRadius: isSelected ? 18 : 8,
            spreadRadius: isSelected ? 1 : 0,
            offset: Offset(0, isSelected ? 10 : 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                game['image']!,
                fit: BoxFit.contain,
                width: double.infinity,
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
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              game['title'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.comicNeue(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1C1C1E),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
