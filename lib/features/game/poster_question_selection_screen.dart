import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class PosterQuestionSelectionScreen extends StatefulWidget {
  final String categoryTitle;

  const PosterQuestionSelectionScreen({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<PosterQuestionSelectionScreen> createState() => _PosterQuestionSelectionScreenState();
}

class _PosterQuestionSelectionScreenState extends State<PosterQuestionSelectionScreen> {
  late PageController _pageController;
  double _currentPage = 2.0;

  late List<Map<String, dynamic>> _questions;

  final Map<String, List<Map<String, dynamic>>> _categoryQuestions = {
    'Human Body': [
      {'title': 'How does the heart work?', 'image': 'https://picsum.photos/400/400?random=131'},
      {'title': 'Why do we need sleep?', 'image': 'https://picsum.photos/400/400?random=132'},
      {'title': 'How do bones stay strong?', 'image': 'https://picsum.photos/400/400?random=133'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'What makes us taste food?', 'image': 'https://picsum.photos/400/400?random=134'},
      {'title': 'How does the brain think?', 'image': 'https://picsum.photos/400/400?random=135'},
    ],
    'Science': [
      {'title': 'Why is the sky blue?', 'image': 'https://picsum.photos/400/400?random=161'},
      {'title': 'How do volcanoes erupt?', 'image': 'https://picsum.photos/400/400?random=162'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'What are stars made of?', 'image': 'https://picsum.photos/400/400?random=163'},
      {'title': 'How does electricity work?', 'image': 'https://picsum.photos/400/400?random=164'},
      {'title': 'Why does ice float?', 'image': 'https://picsum.photos/400/400?random=165'},
    ],
    'Forests & Animals': [
      {'title': 'Why do lions roar?', 'image': 'https://picsum.photos/400/400?random=121'},
      {'title': 'How do birds fly?', 'image': 'https://picsum.photos/400/400?random=122'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'Why do chameleons change color?', 'image': 'https://picsum.photos/400/400?random=123'},
      {'title': 'How do trees breathe?', 'image': 'https://picsum.photos/400/400?random=124'},
      {'title': 'What do sea turtles eat?', 'image': 'https://picsum.photos/400/400?random=125'},
    ],
    'Earth and World': [
      {'title': 'Why does it rain?', 'image': 'https://picsum.photos/400/400?random=141'},
      {'title': 'How are mountains formed?', 'image': 'https://picsum.photos/400/400?random=142'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'Why is the ocean salty?', 'image': 'https://picsum.photos/400/400?random=143'},
      {'title': 'How big is the universe?', 'image': 'https://picsum.photos/400/400?random=144'},
    ],
    'Transportation': [
      {'title': 'How do airplanes stay in the air?', 'image': 'https://picsum.photos/400/400?random=111'},
      {'title': 'How fast can bullet trains go?', 'image': 'https://picsum.photos/400/400?random=112'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'How do rockets reach space?', 'image': 'https://picsum.photos/400/400?random=113'},
      {'title': 'How do submarines dive deep?', 'image': 'https://picsum.photos/400/400?random=114'},
    ],
    'Community Helpers': [
      {'title': 'What do firefighters do?', 'image': 'https://picsum.photos/400/400?random=181'},
      {'title': 'How do doctors heal people?', 'image': 'https://picsum.photos/400/400?random=182'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'How do architects build houses?', 'image': 'https://picsum.photos/400/400?random=183'},
      {'title': 'What does an astronaut study?', 'image': 'https://picsum.photos/400/400?random=184'},
    ],
    'Women Heroes': [
      {'title': 'Marie Curie & Science', 'image': 'https://picsum.photos/400/400?random=151'},
      {'title': 'Amelia Earhart & Aviation', 'image': 'https://picsum.photos/400/400?random=152'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'Rosa Parks & Courage', 'image': 'https://picsum.photos/400/400?random=153'},
      {'title': 'Ada Lovelace & Coding', 'image': 'https://picsum.photos/400/400?random=154'},
    ],
    'Festivals': [
      {'title': 'Why do we celebrate Diwali?', 'image': 'https://picsum.photos/400/400?random=171'},
      {'title': 'Traditions of Christmas', 'image': 'https://picsum.photos/400/400?random=172'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'Colors of Holi', 'image': 'https://picsum.photos/400/400?random=173'},
      {'title': 'Lantern Festival Wonders', 'image': 'https://picsum.photos/400/400?random=174'},
    ],
    'Feelings': [
      {'title': 'Why do we feel happy?', 'image': 'https://picsum.photos/400/400?random=191'},
      {'title': 'How to handle feeling angry', 'image': 'https://picsum.photos/400/400?random=192'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'What does courage feel like?', 'image': 'https://picsum.photos/400/400?random=193'},
      {'title': 'Why it is okay to be sad', 'image': 'https://picsum.photos/400/400?random=194'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _questions = _categoryQuestions[widget.categoryTitle] ?? [
      {'title': 'What makes things grow?', 'image': 'https://picsum.photos/400/400?random=201'},
      {'title': 'How do stars shine?', 'image': 'https://picsum.photos/400/400?random=202'},
      {'title': 'Ask Your Question', 'isSpecial': true},
      {'title': 'Why do we dream?', 'image': 'https://picsum.photos/400/400?random=203'},
      {'title': 'How do magnets work?', 'image': 'https://picsum.photos/400/400?random=204'},
    ];

    final initial = (_questions.length / 2).floor();
    _currentPage = initial.toDouble();
    _pageController = PageController(
      initialPage: initial,
      viewportFraction: 0.185,
    );

    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? initial.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onCardTapped(int index) {
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

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: _questions.length,
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
                                      onTap: () => _onCardTapped(index),
                                      child: _buildCard(_questions[index], isSelected),
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
                'Pick a poster question about ${widget.categoryTitle}!',
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
                  color: const Color(0xFF80CBC4).withValues(alpha: 0.5),
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

  Widget _buildCard(Map<String, dynamic> item, bool isSelected) {
    if (item['isSpecial'] == true) {
      return _buildSpecialCard(item, isSelected);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.22 : 0.04),
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
              child: Image.network(
                item['image'] ?? 'https://picsum.photos/400/400',
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.center,
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
            padding: const EdgeInsets.only(top: 6, bottom: 2, left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              item['title'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: isSelected ? 14 : 12.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialCard(Map<String, dynamic> item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.22 : 0.04),
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
                  color: Color(0xFF95DBAC),
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
                              color: Color(0xFFFFD54F),
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
              item['title'] ?? 'Ask Your Question',
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
