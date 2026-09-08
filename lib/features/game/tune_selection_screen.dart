import 'package:little_kids_ai/core/common_imports.dart';

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
    {'title': 'ABC Song', 'id': '4'},
  ];

  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.36,
    );
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? 0.0;
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
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC), // Light blue background
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Select a tune to begin',
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    // Duck Character
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Image.asset(
                        'assets/images/duck_singer.png',
                        height: MediaQuery.of(context).size.height * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Tunes Carousel with PageView.builder
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 280,
                        width: MediaQuery.of(context).size.width * 0.72,
                        child: PageView.builder(
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

                                final double progress = (1.0 - (pageOffset.abs() * 0.6)).clamp(0.0, 1.0);
                                final double scale = 0.88 + (progress * 0.16);
                                final bool isSelected = pageOffset.abs() < 0.45;

                                return Center(
                                  child: Transform.scale(
                                    scale: scale,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        if (isSelected) {
                                          // Play/Select tune
                                        } else {
                                          _pageController.animateToPage(
                                            index,
                                            duration: const Duration(milliseconds: 350),
                                            curve: Curves.easeOutCubic,
                                          );
                                        }
                                      },
                                      child: _buildTuneCard(tunes[index], isSelected),
                                    ),
                                  ),
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

          // Close button
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F), // Yellow
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                child: const Icon(Icons.close, color: Colors.black54, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTuneCard(Map<String, String> tune, bool isSelected) {
    return SizedBox(
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer decorative circle
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isSelected ? 0.4 : 0.2),
              shape: BoxShape.circle,
            ),
          ),
          // Main Black Circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFFFFD54F) : const Color(0xFFB3E5FC),
                width: isSelected ? 6 : 8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isSelected ? 0.35 : 0.2),
                  blurRadius: isSelected ? 14 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    tune['title']!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.comicNeue(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SELECT',
                    style: GoogleFonts.comicNeue(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
