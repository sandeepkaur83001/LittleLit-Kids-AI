import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class GameHubScreen extends StatefulWidget {
  const GameHubScreen({super.key});

  @override
  State<GameHubScreen> createState() => _GameHubScreenState();
}

class _GameHubScreenState extends State<GameHubScreen> {
  final List<Map<String, String>> games = [
    {'title': 'Make Posters', 'image': 'https://picsum.photos/200/300?random=1'},
    {'title': 'Write Storybooks', 'image': 'https://picsum.photos/200/300?random=2'},
    {'title': 'Design Puzzles', 'image': 'https://picsum.photos/200/300?random=3'},
    {'title': 'Design Stuff', 'image': 'https://picsum.photos/200/300?random=4'},
    {'title': 'Create Songs', 'image': 'https://picsum.photos/200/300?random=5'},
    {'title': 'Coloring Art', 'image': 'https://picsum.photos/200/300?random=6'},
    {'title': 'Build Projects', 'image': 'https://picsum.photos/200/300?random=7'},
  ];

  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.24,
  );
  double _currentPage = 1.0;

  @override
  void initState() {
    super.initState();
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
      child: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double itemWidth = (width * 0.22).clamp(180.0, 260.0);

                return PageView.builder(
                  controller: _pageController,
                  itemCount: games.length,
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

                        final double progress = (1.0 - (pageOffset.abs() * 0.7)).clamp(0.0, 1.0);
                        final double scale = 0.85 + (progress * 0.22);
                        final double yOffset = -14.0 * progress;
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
                                      // Selected action
                                    } else {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 350),
                                        curve: Curves.easeOutCubic,
                                      );
                                    }
                                  },
                                  child: _buildGameCard(games[index], isSelected),
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
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildRoundIcon(Icons.person_outline),
              const SizedBox(width: 10),
              _buildRoundIcon(Icons.music_note),
              const SizedBox(width: 10),
              _buildRoundIcon(Icons.help_outline),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_fix_high, color: Colors.yellow, size: 30),
          ),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.orange),
                  Text(
                    'My\nStuff',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              const Icon(Icons.card_giftcard, color: Colors.red, size: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade400.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildGameCard(Map<String, String> game, bool isSelected) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                game['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              game['title']!,
              style: GoogleFonts.comicNeue(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
