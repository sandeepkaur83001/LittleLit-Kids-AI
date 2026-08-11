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

class _GameScreenState extends State<GameScreen> {
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
    viewportFraction: 0.21, // Reduced gap between cards
  );
  double _currentPage = 1.0;

  @override
  void initState() {
    super.initState();
    // _loadGameData(); // API Call: Fetching available games from server
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
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
            child: PageView.builder(
              controller: _pageController,
              itemCount: games.length,
              padEnds: true,

              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                double diff = (index - _currentPage);

                // Pop effect logic
                double value = (1 - (diff.abs() * 0.8)).clamp(0.0, 1.0);

                // Scale from 0.85 to 1.1 (Slight scale)
                double scale = 0.85 + (value * 0.25);


                return Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_pageController.page?.round() == index) {
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
                    child: Transform(
                      transform: Matrix4.identity()
                        ..scale(scale)
                        ,
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 250,
                        margin: EdgeInsets.zero,
                        child: _buildGameCard(games[index], value > 0.8),
                      ),
                    ),
                  ),
                );
              },
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
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration:  BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/magic_image.png',
                height: 60,
                width: 60,
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
                              fontSize: 18,
        fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            'Stuff',
                            style: TextStyle(
                              fontSize: 18,
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
                fit: BoxFit.cover,
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
