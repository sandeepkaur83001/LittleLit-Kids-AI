import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class BookCreationScreen extends StatefulWidget {
  const BookCreationScreen({super.key});

  @override
  State<BookCreationScreen> createState() => _BookCreationScreenState();
}

class _BookCreationScreenState extends State<BookCreationScreen> {
  final List<Map<String, String>> bookThemes = [
    {
      'title': 'Fantasy',
      'image': 'assets/images/fantasy_book.png',
    },
    {
      'title': 'Mystery',
      'image': 'assets/images/mystery.png',
    },
    {
      'title': 'Diary',
      'image': 'assets/images/diary_book.png',
    },
    {
      'title': 'Theme',
      'image': 'assets/images/theme_book.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/src_assets_background_language_back.png',
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.94,
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
            color: const Color(0xFF95dbac).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            children: [
              // Top-left book mascot character
              Positioned(
                top: 14,
                left: 20,
                child: Image.asset(
                  'assets/images/src_assets_icons_scribble.png',
                  height: 105,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/book.png',
                    height: 105,
                  ),
                ),
              ),

              // Top-right close button
              Positioned(
                top: 16,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCEDC8), // Light lime-green circle
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Color(0xFF374151), size: 26),
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.fromLTRB(130, 20, 70, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Heading Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'First, lets build an idea for your book. What kind of story world do you want to create?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 4 Book Cards Row
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: bookThemes.map((theme) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SubscriptionScreen(),
                                    ),
                                  );
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Center(
                                  child: Image.asset(
                                    theme['image']!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
}
