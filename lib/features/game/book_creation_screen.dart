import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/story_reader_screen.dart';

class BookCreationScreen extends StatefulWidget {
  const BookCreationScreen({super.key});

  @override
  State<BookCreationScreen> createState() => _BookCreationScreenState();
}

class _BookCreationScreenState extends State<BookCreationScreen> {
  final List<Map<String, String>> bookThemes = [
    {'title': 'Theme', 'image': 'https://picsum.photos/400/400?random=21'},
    {'title': 'Fantasy', 'image': 'https://picsum.photos/400/400?random=22'},
    {'title': 'Mystery', 'image': 'https://picsum.photos/400/400?random=23'},
    {'title': 'Diary', 'image': 'https://picsum.photos/400/400?random=24'},
  ];

  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.30,
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
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: const Color(0xFF80CBC4).withOpacity(0.6), // Light teal overlay
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              // Character in top left
              Positioned(
                top: 20,
                left: 30,
                child: Image.asset(
                  'assets/images/src_assets_images_just_read_story.png',
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/book.png',
                    height: 120,
                  ),
                ),
              ),

              // Close Button
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/images/src_assets_icons_btn_cross.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC5E1A5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.black54, size: 28),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(160, 30, 60, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First, lets build an idea for your book. What kind of story world do you want to create?',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.comicNeue(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: bookThemes.length,
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

                              final double progress = (1.0 - (pageOffset.abs() * 0.5)).clamp(0.0, 1.0);
                              final double scale = 0.88 + (progress * 0.16);
                              final bool isSelected = pageOffset.abs() < 0.45;

                              return Center(
                                child: Transform.scale(
                                  scale: scale,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => StoryReaderScreen(
                                            storyTitle: '${bookThemes[index]['title']} Adventure',
                                            themeName: bookThemes[index]['title']!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: _buildBookCard(
                                      bookThemes[index]['title']!,
                                      bookThemes[index]['image']!,
                                      isSelected,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(String title, String imageUrl, bool isSelected) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.25 : 0.1),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/src_assets_images_defalt_cover.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.comicNeue(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
