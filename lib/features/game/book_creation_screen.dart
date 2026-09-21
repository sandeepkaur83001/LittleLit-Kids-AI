import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:get/get.dart';
import 'package:little_kids_ai/features/game/controllers/categories_controller.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class BookCreationScreen extends StatefulWidget {
  final CategoryModel? category;
  const BookCreationScreen({super.key, this.category});

  @override
  State<BookCreationScreen> createState() => _BookCreationScreenState();
}

class _BookCreationScreenState extends State<BookCreationScreen> {
  final CategoriesController _categoriesController = Get.find<CategoriesController>();

  final List<Map<String, String>> _fallbackBookThemes = [
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

  CategoryModel? _findParentCategory() {
    if (widget.category != null && widget.category!.children != null && widget.category!.children!.isNotEmpty) {
      return widget.category;
    }
    final serverCategories = _categoriesController.categoryList;
    if (serverCategories.isNotEmpty) {
      return serverCategories.firstWhereOrNull((c) {
        final cName = (c.name ?? '').toLowerCase();
        final cSlug = (c.slug ?? '').toLowerCase();
        return cSlug.contains('story') || cName.contains('story') || (c.id == 19 || c.id == 10);
      });
    }
    return null;
  }

  String _getFallbackAsset(String? title) {
    final t = (title ?? '').toLowerCase();
    if (t.contains('fantasy')) return 'assets/images/fantasy_book.png';
    if (t.contains('mystery')) return 'assets/images/mystery.png';
    if (t.contains('diary')) return 'assets/images/diary_book.png';
    if (t.contains('theme')) return 'assets/images/theme_book.png';
    return 'assets/images/fantasy_book.png';
  }

  List<Map<String, dynamic>> _getEffectiveThemes() {
    final parent = _findParentCategory();
    final children = parent?.children;
    if (children != null && children.isNotEmpty) {
      return children.map((c) {
        return {
          'id': c.id,
          'title': c.name ?? '',
          'image': c.iconUrl ?? c.icon ?? c.image ?? '',
          'fallbackAsset': _getFallbackAsset(c.name),
          'model': c,
        };
      }).toList();
    }
    return _fallbackBookThemes;
  }

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

                    // Book Cards Row
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _getEffectiveThemes().map((theme) {
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
                                  child: _buildThemeImage(
                                    theme['image'] as String?,
                                    theme['fallbackAsset'] as String?,
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

  Widget _buildThemeImage(String? imageUrl, String? fallbackAsset) {
    if (imageUrl != null && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          if (fallbackAsset != null && fallbackAsset.isNotEmpty) {
            return Image.asset(
              fallbackAsset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 60, color: Colors.white),
            );
          }
          return const Icon(Icons.book, size: 60, color: Colors.white);
        },
      );
    } else if (imageUrl != null && imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 60, color: Colors.white),
      );
    } else if (fallbackAsset != null && fallbackAsset.isNotEmpty) {
      return Image.asset(
        fallbackAsset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 60, color: Colors.white),
      );
    }
    return const Icon(Icons.book, size: 60, color: Colors.white);
  }
}
