import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/poster_question_selection_screen.dart';
import 'package:little_kids_ai/features/game/controllers/categories_controller.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String gameTitle;
  final CategoryModel? category;
  const CategorySelectionScreen({super.key, required this.gameTitle, this.category});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final CategoriesController _categoriesController = Get.find<CategoriesController>();

  final List<Map<String, dynamic>> _fallbackCategories = [
    {'title': 'Community Helpers', 'image': 'assets/images/community_helpers.png'},
    {'title': 'Earth and World', 'image': 'assets/images/earth_and_world.png'},
    {'title': 'Feelings', 'image': 'assets/images/feelings.png'},
    {'title': 'Festivals', 'image': 'assets/images/festivals.png'},
    {'title': 'Ask Your Question', 'isSpecial': true},
    {'title': 'Human Body', 'image': 'assets/images/human_body.png'},
    {'title': 'Science', 'image': 'assets/images/science.png'},
    {'title': 'Transportation', 'image': 'assets/images/transportation.png'},
    {'title': 'Women Heroes', 'image': 'assets/images/women_heroes.png'},
  ];

  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty && _categoriesController.categoryList.isEmpty) {
      _categoriesController.fetchCategories();
    }
    const double viewportFraction = 0.185;
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: viewportFraction,
    );
    _currentPage = 0.0;

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

  CategoryModel? _findParentCategory() {
    if (widget.category != null && widget.category!.children != null && widget.category!.children!.isNotEmpty) {
      return widget.category;
    }
    final serverCategories = _categoriesController.categoryList;
    if (serverCategories.isNotEmpty) {
      if (widget.category?.id != null) {
        final byId = serverCategories.firstWhereOrNull((c) => c.id == widget.category!.id);
        if (byId != null) return byId;
      }
      final title = widget.gameTitle.toLowerCase().replaceAll(' ', '-').replaceAll('_', '-');
      final matched = serverCategories.firstWhereOrNull((c) {
        final cName = (c.name ?? '').toLowerCase().replaceAll(' ', '-').replaceAll('_', '-');
        final cSlug = (c.slug ?? '').toLowerCase().replaceAll(' ', '-').replaceAll('_', '-');
        return cName == title || (cSlug.isNotEmpty && (cSlug == title || title.contains(cSlug) || cSlug.contains(title)));
      });
      if (matched != null) return matched;
      if (widget.category != null) return widget.category;
      return serverCategories.first;
    }
    return widget.category;
  }

  List<Map<String, dynamic>> _getEffectiveCategories() {
    // Touch reactive list so Obx always has an observable to track
    final _ = _categoriesController.categoryList.length;
    final parent = _findParentCategory();
    final children = parent?.children;

    if (children != null && children.isNotEmpty) {
      final sharedChildren = children.firstWhereOrNull((c) => c.children != null && c.children!.isNotEmpty)?.children;

      final list = children.map((c) {
        final isSpecial = (c.slug == 'your-theme' || c.name?.toLowerCase() == 'ask your question' || c.isSpecial == true);
        if ((c.children == null || c.children!.isEmpty) && sharedChildren != null && sharedChildren.isNotEmpty) {
          c.children = sharedChildren;
        }
        return {
          'id': c.id,
          'title': c.name ?? '',
          'image': c.iconUrl ?? c.icon ?? '',
          'isSpecial': isSpecial,
          'model': c,
        };
      }).toList();

      if (!list.any((item) => item['isSpecial'] == true)) {
        final middleIndex = (list.length / 2).floor();
        list.insert(middleIndex, {'title': 'Ask Your Question', 'isSpecial': true});
      }
      return list;
    }
    return _fallbackCategories;
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/src_assets_background_litto_back.png',
      child: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double width = constraints.maxWidth;
                    final double fraction = _pageController.viewportFraction;
                    final double slotWidth = width * fraction;
                    final double itemWidth = slotWidth + 1.0;
                    final double itemHeight = math.min(itemWidth * 1.38, math.min(constraints.maxHeight * 0.80, 280.0));

                    return Obx(() {
                      final categories = _getEffectiveCategories();

                      return PageView.builder(
                        controller: _pageController,
                        itemCount: categories.length,
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

                              final double progress = (1.0 - (pageOffset.abs() * 0.9)).clamp(0.0, 1.0);
                              final double scale = 1.0 + (progress * 0.18);
                              final double yOffset = -16.0 * progress;
                              final bool isSelected = pageOffset.abs() < 0.45;

                              return Center(
                                child: Transform.translate(
                                  offset: Offset(0, yOffset),
                                  child: Transform.scale(
                                    scale: scale,
                                    child: SizedBox(
                                      width: itemWidth,
                                      height: itemHeight,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          if (isSelected) {
                                            if (categories[index]['isSpecial'] == true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => PosterQuestionSelectionScreen(
                                                    categoryTitle: categories[index]['title'] ?? 'Science',
                                                    category: categories[index]['model'] as CategoryModel?,
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            final model = categories[index]['model'] as CategoryModel?;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PosterQuestionSelectionScreen(
                                                  categoryTitle: categories[index]['title'] ?? 'Science',
                                                  category: model,
                                                ),
                                              ),
                                            );
                                          } else {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(milliseconds: 350),
                                              curve: Curves.easeOutCubic,
                                            );
                                          }
                                        },
                                        child: _buildCategoryCard(categories[index], isSelected),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'What kind of question should we learn about today?',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF80CBC4).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.black54, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, bool isSelected) {
    if (category['isSpecial'] == true) {
      return _buildSpecialCard(category, isSelected);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.04),
            blurRadius: isSelected ? 18 : 3,
            spreadRadius: isSelected ? 2 : 0,
            offset: Offset(0, isSelected ? 8 : 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildCardImage(category['image']),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              category['title'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: isSelected ? 15 : 13.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardImage(String? imagePath) {
    return AppCardImage(
      imageUrl: imagePath,
      fallbackIcon: Icons.palette_outlined,
    );
  }

  Widget _buildSpecialCard(Map<String, dynamic> category, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.22 : 0.04),
            blurRadius: isSelected ? 18 : 3,
            spreadRadius: isSelected ? 2 : 0,
            offset: Offset(0, isSelected ? 8 : 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF95DBAC), // Green card color #95dbac
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Type or Talk...',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD54F), // Golden yellow mic
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mic, color: Colors.white, size: 28),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward, color: Color(0xFF95DBAC), size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              category['title'],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: isSelected ? 15 : 13.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
