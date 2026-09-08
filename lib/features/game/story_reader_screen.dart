import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class StoryPageData {
  final String image;
  final String title;
  final String content;
  final String narration;

  StoryPageData({
    required this.image,
    required this.title,
    required this.content,
    required this.narration,
  });
}

class StoryReaderScreen extends StatefulWidget {
  final String storyTitle;
  final String themeName;

  const StoryReaderScreen({
    super.key,
    required this.storyTitle,
    required this.themeName,
  });

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  int _currentPageIndex = 0;
  bool _isSpeaking = false;

  late final List<StoryPageData> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      StoryPageData(
        image: 'assets/images/coloring_arts.png',
        title: 'Chapter 1: The Secret Meadow',
        content: 'Once upon a time in a magical valley, a brave young explorer set off to find the hidden rainbow crystal.',
        narration: '"Look at those glowing butterflies leading the way!" whispered the guide.',
      ),
      StoryPageData(
        image: 'assets/images/chameleon.png',
        title: 'Chapter 2: The Color Master',
        content: 'Deep in the emerald forest, they met Crafty the Chameleon, who could paint the skies with just a swish of his tail.',
        narration: '"Choose your favorite color and follow me into the sparkling caves!" said Crafty.',
      ),
      StoryPageData(
        image: 'assets/images/duck_singer.png',
        title: 'Chapter 3: The Song of Victory',
        content: 'At the mountain summit, all the friends gathered to celebrate with musical notes and magical starry fireworks.',
        narration: '"We did it! The adventure has just begun!" cheered the happy companions.',
      ),
    ];
  }

  void _toggleTTS() {
    setState(() {
      _isSpeaking = !_isSpeaking;
    });
  }

  void _nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      setState(() {
        _currentPageIndex++;
        _isSpeaking = false;
      });
    }
  }

  void _prevPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
        _isSpeaking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _pages[_currentPageIndex];

    return GameBackground(
      backgroundImage: 'assets/images/landscape_background_clean.png',
      child: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  height: MediaQuery.of(context).size.height * 0.82,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6), // Parchment / open book color
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFD7CCC8), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Center Spine Divider
                      Center(
                        child: Container(
                          width: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.brown.shade200.withOpacity(0.2),
                                Colors.brown.shade400.withOpacity(0.6),
                                Colors.brown.shade200.withOpacity(0.2),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Two Pages Layout (Left Illustration, Right Story Text)
                      Row(
                        children: [
                          // Left Page (Artwork Illustration)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    currentPage.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 80, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Right Page (Story Content & Narration)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 24, 28, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Story Chapter Title
                                  Text(
                                    currentPage.title,
                                    style: GoogleFonts.comicNeue(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Story Paragraph Text
                                  Text(
                                    currentPage.content,
                                    style: GoogleFonts.comicNeue(
                                      fontSize: 17,
                                      height: 1.35,
                                      color: const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Speech / Character Narration Bubble
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F7FA),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: const Color(0xFF80DEEA), width: 1),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF00838F), size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            currentPage.narration,
                                            style: GoogleFonts.comicNeue(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF006064),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),

                                  // Bottom Controls (TTS Read Aloud & Page Turners)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Read Aloud / TTS Button
                                      GestureDetector(
                                        onTap: _toggleTTS,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _isSpeaking ? const Color(0xFFFFD54F) : Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: const Color(0xFFB0BEC5)),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                _isSpeaking
                                                    ? 'assets/images/src_assets_images_tts.png'
                                                    : 'assets/images/src_assets_images_non_tts.png',
                                                height: 22,
                                                width: 22,
                                                fit: BoxFit.contain,
                                                errorBuilder: (_, __, ___) => Icon(
                                                  _isSpeaking ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                                                  color: const Color(0xFF37474F),
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                _isSpeaking ? 'Reading...' : 'Read to Me',
                                                style: GoogleFonts.comicNeue(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFF37474F),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Page Count Badge
                                      Text(
                                        'Page ${_currentPageIndex + 1} of ${_pages.length}',
                                        style: GoogleFonts.comicNeue(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),

                                      // Prev & Next Controls
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: _currentPageIndex > 0 ? _prevPage : null,
                                            child: Opacity(
                                              opacity: _currentPageIndex > 0 ? 1.0 : 0.4,
                                              child: Image.asset(
                                                'assets/images/src_assets_images_step_back.png',
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.contain,
                                                errorBuilder: (_, __, ___) => const Icon(Icons.arrow_back_ios_rounded, size: 20),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: _currentPageIndex < _pages.length - 1 ? _nextPage : null,
                                            child: Opacity(
                                              opacity: _currentPageIndex < _pages.length - 1 ? 1.0 : 0.4,
                                              child: Image.asset(
                                                'assets/images/src_assets_images_step_next.png',
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.contain,
                                                errorBuilder: (_, __, ___) => const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/images/src_assets_icons_btn_back.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E78C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
          ),
          Text(
            widget.storyTitle,
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
