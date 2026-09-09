import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class TuneSelectionScreen extends StatefulWidget {
  const TuneSelectionScreen({super.key});

  @override
  State<TuneSelectionScreen> createState() => _TuneSelectionScreenState();
}

class _TuneSelectionScreenState extends State<TuneSelectionScreen> {
  final List<Map<String, String>> tunes = [
    {'title': 'Twinkle Twinkle', 'id': '1'},
    {'title': 'Baby Shark', 'id': '2'},
    {'title': 'Mary Had a Little Lamb', 'id': '3'},
    {'title': 'Old MacDonald', 'id': '4'},
    {'title': 'Wheels on the Bus', 'id': '5'},
    {'title': 'Row Row Row Your Boat', 'id': '6'},
  ];

  late PageController _pageController;
  double _currentPage = 1.0;
  String? _playingId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.28,
    );
    _currentPage = 1.0;

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

  void _onTuneCardTapped(int index) {
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
      backgroundImage: 'assets/images/src_assets_background_duck_back_ipad.png',
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              // Top Title
              Center(
                child: Text(
                  'Select a tune to begin',
                  style: GoogleFonts.nunito(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),

              Expanded(
                child: Stack(
                  children: [
                    // Duck Character on the bottom left
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Image.asset(
                        'assets/images/duck_singer.png',
                        height: MediaQuery.of(context).size.height * 0.58,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/duck_image.png',
                          height: MediaQuery.of(context).size.height * 0.58,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Tunes Carousel
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 260,
                        width: MediaQuery.of(context).size.width * 0.76,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return PageView.builder(
                              controller: _pageController,
                              itemCount: tunes.length,
                              physics: const BouncingScrollPhysics(),
                              padEnds: false,
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

                                    final double progress = (1.0 - (pageOffset.abs() * 0.8)).clamp(0.0, 1.0);
                                    final double scale = 0.95 + (progress * 0.15);
                                    final bool isSelected = pageOffset.abs() < 0.45;

                                    return Center(
                                      child: Transform.scale(
                                        scale: scale,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => _onTuneCardTapped(index),
                                          child: _buildTuneCard(tunes[index], isSelected),
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
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Top-Right Close Button
          Positioned(
            top: 16,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F), // Yellow circle
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.close, color: Color(0xFF1E293B), size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTuneCard(Map<String, String> tune, bool isSelected) {
    final bool isPlaying = _playingId == tune['id'];

    return SizedBox(
      width: 225,
      height: 225,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Blue Layer Disc Asset (Full size)
          Image.asset(
            'assets/images/src_assets_icons_music_blue.png',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/src_assets_icons_music_black_blue.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),

          // Inner Black Scalloped Circle Disc Asset (Smaller to reveal outer blue rings)
          Image.asset(
            'assets/images/src_assets_icons_music_black_circle.png',
            width: 142,
            height: 142,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),

          // Inner Content (Play/Stop button, Title, SELECT Button)
          SizedBox(
            width: 135,
            height: 135,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play or Stop Icon
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_playingId == tune['id']) {
                        _playingId = null;
                      } else {
                        _playingId = tune['id'];
                      }
                    });
                  },
                  child: isPlaying
                      ? Image.asset(
                          'assets/images/src_assets_icons_music_blue_stop.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF38BDF8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.stop_rounded, color: Colors.white, size: 20),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                ),
                const SizedBox(height: 4),

                // Tune Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    tune['title']!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // SELECT Button -> Opens SubscriptionScreen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'SELECT',
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF1E293B),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
