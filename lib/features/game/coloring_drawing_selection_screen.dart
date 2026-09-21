import 'dart:math' as math;
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

enum LineDrawingType {
  // Christmas
  gingerbread,
  wreath,
  elf,
  santa,
  catLights,
  chocolateBox,
  // Animals
  lion,
  elephant,
  monkey,
  tiger,
  giraffe,
  // Farm
  barn,
  cow,
  rooster,
  sheep,
  horse,
  // Fruits
  apple,
  banana,
  carrot,
  watermelon,
  // Ocean
  dolphin,
  seaTurtle,
  whale,
  octopus,
  // Custom / Your theme
  magicStar,
  magicDragon,
}

class DrawingItem {
  final String title;
  final String image;
  final LineDrawingType type;
  final bool isFree;

  DrawingItem({
    required this.title,
    this.image = '',
    this.type = LineDrawingType.gingerbread,
    this.isFree = false,
  });
}

class ColoringDrawingSelectionScreen extends StatefulWidget {
  final String themeName;
  final List<DrawingItem> drawings;
  final CategoryModel? category;

  const ColoringDrawingSelectionScreen({
    super.key,
    required this.themeName,
    required this.drawings,
    this.category,
  });

  @override
  State<ColoringDrawingSelectionScreen> createState() => _ColoringDrawingSelectionScreenState();
}

class _ColoringDrawingSelectionScreenState extends State<ColoringDrawingSelectionScreen> {
  late PageController _pageController;
  double _currentPage = 2.0;

  late List<DrawingItem> _items;

  final Map<String, List<DrawingItem>> _themeDrawingsMap = {
    'Christmas': [
      DrawingItem(title: 'Holiday Cat', type: LineDrawingType.catLights),
      DrawingItem(title: 'Christmas Wreath', type: LineDrawingType.wreath),
      DrawingItem(title: 'Christmas Elf', type: LineDrawingType.elf),
      DrawingItem(title: 'Gingerbread Man', type: LineDrawingType.gingerbread),
      DrawingItem(title: 'Chocolate Box', type: LineDrawingType.chocolateBox),
      DrawingItem(title: 'Santa Claus', type: LineDrawingType.santa),
    ],
    'Animal Kingdom': [
      DrawingItem(title: 'Lion', type: LineDrawingType.lion),
      DrawingItem(title: 'Elephant', type: LineDrawingType.elephant),
      DrawingItem(title: 'Playful Monkey', type: LineDrawingType.monkey),
      DrawingItem(title: 'Tiger', type: LineDrawingType.tiger),
      DrawingItem(title: 'Giraffe', type: LineDrawingType.giraffe),
    ],
    'Farm': [
      DrawingItem(title: 'Barn & Field', type: LineDrawingType.barn),
      DrawingItem(title: 'Cow', type: LineDrawingType.cow),
      DrawingItem(title: 'Rooster', type: LineDrawingType.rooster),
      DrawingItem(title: 'Fluffy Sheep', type: LineDrawingType.sheep),
      DrawingItem(title: 'Horse', type: LineDrawingType.horse),
    ],
    'Fruits & Vegetables': [
      DrawingItem(title: 'Apple', type: LineDrawingType.apple),
      DrawingItem(title: 'Banana', type: LineDrawingType.banana),
      DrawingItem(title: 'Happy Carrot', type: LineDrawingType.carrot),
      DrawingItem(title: 'Watermelon Slice', type: LineDrawingType.watermelon),
    ],
    'Ocean Life': [
      DrawingItem(title: 'Dolphin', type: LineDrawingType.dolphin),
      DrawingItem(title: 'Sea Turtle', type: LineDrawingType.seaTurtle),
      DrawingItem(title: 'Whale', type: LineDrawingType.whale),
      DrawingItem(title: 'Octopus', type: LineDrawingType.octopus),
    ],
    'Your theme': [
      DrawingItem(title: 'Magic Star', type: LineDrawingType.magicStar),
      DrawingItem(title: 'Baby Dragon', type: LineDrawingType.magicDragon),
      DrawingItem(title: 'Gingerbread Man', type: LineDrawingType.gingerbread),
      DrawingItem(title: 'Dolphin', type: LineDrawingType.dolphin),
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.category?.children != null && widget.category!.children!.isNotEmpty) {
      _items = widget.category!.children!.map((c) {
        return DrawingItem(
          title: c.name ?? '',
          image: c.iconUrl ?? c.icon ?? c.image ?? '',
        );
      }).toList();
    } else if (widget.drawings.isNotEmpty) {
      _items = widget.drawings;
    } else {
      _items = _themeDrawingsMap[widget.themeName] ?? _themeDrawingsMap['Christmas']!;
    }

    final initial = (_items.length / 2).floor();
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

  void _onDrawingSelected(int index) {
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
      backgroundImage: 'assets/images/src_assets_background_creative_back.png',
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Column(
              children: [
                // Top Prompt Header (Matching reference screenshot)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Ready to make magic? Choose a drawing to color and\nwatch the character or object come to life!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111827),
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Center Themed Drawing Outlines Carousel
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
                        itemCount: _items.length,
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
                                        onTap: () => _onDrawingSelected(index),
                                        child: _buildOutlineCard(_items[index], isSelected),
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
                const SizedBox(height: 45),
              ],
            ),
          ),

          // Bottom Left Brushie Mascot
          Positioned(
            bottom: 6,
            left: 18,
            child: Image.asset(
              'assets/images/src_assets_gifs_brushie.gif',
              height: 125,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/src_assets_icons_intro_brushie.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),

          // Bottom Right Home / Back Button
          Positioned(
            bottom: 16,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF80CBC4).withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Color(0xFF1E293B),
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineCard(DrawingItem item, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isSelected ? 0.22 : 0.04),
            blurRadius: isSelected ? 18 : 3,
            spreadRadius: isSelected ? 2 : 0,
            offset: Offset(0, isSelected ? 8 : 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: (item.image.isNotEmpty && (item.image.startsWith('http') || item.image.startsWith('assets/')))
              ? AppCardImage(
                  imageUrl: item.image,
                  fit: BoxFit.contain,
                  fallbackIcon: Icons.palette_outlined,
                )
              : CustomPaint(
                  painter: LineDrawingPainter(type: item.type),
                  size: Size.infinite,
                ),
        ),
      ),
    );
  }
}

class LineDrawingPainter extends CustomPainter {
  final LineDrawingType type;

  LineDrawingPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF111827)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFF111827)
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;

    switch (type) {
      case LineDrawingType.gingerbread:
        _drawGingerbread(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.wreath:
        _drawWreath(canvas, cx, cy, strokePaint);
        break;
      case LineDrawingType.elf:
        _drawElf(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.santa:
        _drawSanta(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.catLights:
        _drawCatLights(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.chocolateBox:
        _drawChocolateBox(canvas, cx, cy, strokePaint);
        break;
      case LineDrawingType.lion:
        _drawLion(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.elephant:
        _drawElephant(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.monkey:
        _drawMonkey(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.tiger:
        _drawTiger(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.giraffe:
        _drawGiraffe(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.barn:
        _drawBarn(canvas, cx, cy, strokePaint);
        break;
      case LineDrawingType.cow:
        _drawCow(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.rooster:
        _drawRooster(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.sheep:
        _drawSheep(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.horse:
        _drawHorse(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.apple:
        _drawApple(canvas, cx, cy, strokePaint);
        break;
      case LineDrawingType.banana:
        _drawBanana(canvas, cx, cy, strokePaint);
        break;
      case LineDrawingType.carrot:
        _drawCarrot(canvas, cx, cy, strokePaint);
        break;
      case LineDrawingType.watermelon:
        _drawWatermelon(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.dolphin:
        _drawDolphin(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.seaTurtle:
        _drawSeaTurtle(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.whale:
        _drawWhale(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.octopus:
        _drawOctopus(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.magicStar:
        _drawMagicStar(canvas, cx, cy, strokePaint, fillPaint);
        break;
      case LineDrawingType.magicDragon:
        _drawDragon(canvas, cx, cy, strokePaint, fillPaint);
        break;
    }
  }

  void _drawGingerbread(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Head
    canvas.drawCircle(Offset(cx, cy - 35), 20, stroke);
    // Eyes
    canvas.drawCircle(Offset(cx - 7, cy - 38), 2.5, fill);
    canvas.drawCircle(Offset(cx + 7, cy - 38), 2.5, fill);
    // Smile
    final smilePath = Path()
      ..moveTo(cx - 8, cy - 30)
      ..quadraticBezierTo(cx, cy - 23, cx + 8, cy - 30);
    canvas.drawPath(smilePath, stroke);

    // Body & Limbs
    final bodyPath = Path()
      ..moveTo(cx - 10, cy - 16)
      ..quadraticBezierTo(cx - 38, cy - 10, cx - 44, cy + 2) // Left arm
      ..quadraticBezierTo(cx - 38, cy + 16, cx - 18, cy + 8)
      ..lineTo(cx - 18, cy + 22)
      ..quadraticBezierTo(cx - 36, cy + 44, cx - 22, cy + 56) // Left leg
      ..quadraticBezierTo(cx - 8, cy + 54, cx - 4, cy + 30)
      ..lineTo(cx + 4, cy + 30)
      ..quadraticBezierTo(cx + 8, cy + 54, cx + 22, cy + 56) // Right leg
      ..quadraticBezierTo(cx + 36, cy + 44, cx + 18, cy + 22)
      ..lineTo(cx + 18, cy + 8)
      ..quadraticBezierTo(cx + 38, cy + 16, cx + 44, cy + 2) // Right arm
      ..quadraticBezierTo(cx + 38, cy - 10, cx + 10, cy - 16)
      ..close();
    canvas.drawPath(bodyPath, stroke);

    // 3 Buttons
    canvas.drawCircle(Offset(cx, cy - 5), 3, stroke);
    canvas.drawCircle(Offset(cx, cy + 9), 3, stroke);
    canvas.drawCircle(Offset(cx, cy + 22), 3, stroke);

    // Icing stripes on wrists & ankles
    canvas.drawLine(Offset(cx - 38, cy - 4), Offset(cx - 32, cy + 8), stroke);
    canvas.drawLine(Offset(cx + 38, cy - 4), Offset(cx + 32, cy + 8), stroke);
    canvas.drawLine(Offset(cx - 24, cy + 40), Offset(cx - 10, cy + 44), stroke);
    canvas.drawLine(Offset(cx + 24, cy + 40), Offset(cx + 10, cy + 44), stroke);
  }

  void _drawWreath(Canvas canvas, double cx, double cy, Paint stroke) {
    canvas.drawCircle(Offset(cx, cy + 8), 44, stroke);
    canvas.drawCircle(Offset(cx, cy + 8), 24, stroke);
    // Ribbon bow at top
    final bowPath = Path()
      ..moveTo(cx, cy - 28)
      ..cubicTo(cx - 30, cy - 50, cx - 35, cy - 18, cx - 4, cy - 26)
      ..moveTo(cx, cy - 28)
      ..cubicTo(cx + 30, cy - 50, cx + 35, cy - 18, cx + 4, cy - 26);
    canvas.drawPath(bowPath, stroke);
    canvas.drawCircle(Offset(cx, cy - 27), 7, stroke);
    // Ribbon tails
    canvas.drawLine(Offset(cx - 5, cy - 20), Offset(cx - 20, cy - 2), stroke);
    canvas.drawLine(Offset(cx + 5, cy - 20), Offset(cx + 20, cy - 2), stroke);
    // Leaf details
    for (int i = 0; i < 6; i++) {
      final double ang = i * 3.14159 / 3;
      final double lx = cx + 34 * (i % 2 == 0 ? 1 : -1);
      final double ly = cy + 8 + 34 * (i > 2 ? 1 : -1);
      canvas.drawCircle(Offset(cx + 34 * (i == 0 ? 1 : -1), cy + 8), 3, stroke);
    }
  }

  void _drawElf(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Face
    canvas.drawCircle(Offset(cx, cy - 10), 20, stroke);
    // Pointy hat
    final hatPath = Path()
      ..moveTo(cx - 22, cy - 16)
      ..quadraticBezierTo(cx, cy - 60, cx + 36, cy - 54)
      ..quadraticBezierTo(cx + 10, cy - 26, cx + 22, cy - 16)
      ..close();
    canvas.drawPath(hatPath, stroke);
    canvas.drawCircle(Offset(cx + 38, cy - 54), 5, stroke); // Pompom
    // Ears
    canvas.drawPath(Path()..moveTo(cx - 20, cy - 12)..lineTo(cx - 32, cy - 16)..lineTo(cx - 19, cy - 4), stroke);
    canvas.drawPath(Path()..moveTo(cx + 20, cy - 12)..lineTo(cx + 32, cy - 16)..lineTo(cx + 19, cy - 4), stroke);
    // Eyes & Smile
    canvas.drawCircle(Offset(cx - 7, cy - 10), 2.5, fill);
    canvas.drawCircle(Offset(cx + 7, cy - 10), 2.5, fill);
    canvas.drawPath(Path()..moveTo(cx - 6, cy - 2)..quadraticBezierTo(cx, cy + 4, cx + 6, cy - 2), stroke);
    // Collar & Body
    final body = Path()
      ..moveTo(cx - 15, cy + 10)
      ..lineTo(cx - 25, cy + 40)
      ..lineTo(cx + 25, cy + 40)
      ..lineTo(cx + 15, cy + 10)
      ..close();
    canvas.drawPath(body, stroke);
    // Legs
    canvas.drawLine(Offset(cx - 10, cy + 40), Offset(cx - 10, cy + 56), stroke);
    canvas.drawLine(Offset(cx + 10, cy + 40), Offset(cx + 10, cy + 56), stroke);
    // Shoes
    canvas.drawPath(Path()..moveTo(cx - 10, cy + 56)..quadraticBezierTo(cx - 22, cy + 58, cx - 20, cy + 50), stroke);
    canvas.drawPath(Path()..moveTo(cx + 10, cy + 56)..quadraticBezierTo(cx + 22, cy + 58, cx + 20, cy + 50), stroke);
  }

  void _drawSanta(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Hat
    final hat = Path()
      ..moveTo(cx - 26, cy - 24)
      ..quadraticBezierTo(cx - 6, cy - 62, cx + 34, cy - 46)
      ..quadraticBezierTo(cx + 16, cy - 28, cx + 26, cy - 24)
      ..close();
    canvas.drawPath(hat, stroke);
    canvas.drawCircle(Offset(cx + 36, cy - 44), 6, stroke);
    // Hat brim
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - 22), width: 56, height: 12), const Radius.circular(6)), stroke);
    // Eyes & Nose
    canvas.drawCircle(Offset(cx - 8, cy - 14), 2.5, fill);
    canvas.drawCircle(Offset(cx + 8, cy - 14), 2.5, fill);
    canvas.drawCircle(Offset(cx, cy - 8), 5, stroke);
    // Fluffy Beard
    final beard = Path()
      ..moveTo(cx - 26, cy - 16)
      ..cubicTo(cx - 40, cy + 10, cx - 20, cy + 48, cx, cy + 48)
      ..cubicTo(cx + 20, cy + 48, cx + 40, cy + 10, cx + 26, cy - 16)
      ..quadraticBezierTo(cx, cy - 4, cx - 26, cy - 16);
    canvas.drawPath(beard, stroke);
    // Waving Hand
    canvas.drawCircle(Offset(cx - 38, cy - 14), 8, stroke);
  }

  void _drawCatLights(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Cat Head
    canvas.drawCircle(Offset(cx, cy - 14), 24, stroke);
    // Ears
    canvas.drawPath(Path()..moveTo(cx - 22, cy - 24)..lineTo(cx - 26, cy - 46)..lineTo(cx - 6, cy - 34), stroke);
    canvas.drawPath(Path()..moveTo(cx + 22, cy - 24)..lineTo(cx + 26, cy - 46)..lineTo(cx + 6, cy - 34), stroke);
    // Eyes & Nose
    canvas.drawCircle(Offset(cx - 8, cy - 16), 3, fill);
    canvas.drawCircle(Offset(cx + 8, cy - 16), 3, fill);
    canvas.drawPath(Path()..moveTo(cx - 4, cy - 10)..lineTo(cx + 4, cy - 10)..lineTo(cx, cy - 6)..close(), fill);
    // Body
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 24), width: 44, height: 50), const Radius.circular(20)), stroke);
    // String lights wrapped around
    final lightsPath = Path()
      ..moveTo(cx - 22, cy + 10)
      ..quadraticBezierTo(cx, cy + 22, cx + 22, cy + 14)
      ..quadraticBezierTo(cx, cy + 38, cx - 22, cy + 34);
    canvas.drawPath(lightsPath, stroke);
    // Bulbs
    for (int i = 0; i < 5; i++) {
      final double bx = cx - 18 + i * 9;
      canvas.drawCircle(Offset(bx, cy + 14 + (i % 2 == 0 ? 4 : 16)), 3, stroke);
    }
  }

  void _drawChocolateBox(Canvas canvas, double cx, double cy, Paint stroke) {
    // Heart shape box
    final heart = Path()
      ..moveTo(cx, cy + 38)
      ..cubicTo(cx - 55, cy + 8, cx - 50, cy - 36, cx, cy - 16)
      ..cubicTo(cx + 50, cy - 36, cx + 55, cy + 8, cx, cy + 38);
    canvas.drawPath(heart, stroke);
    // Chocolates inside
    canvas.drawCircle(Offset(cx - 18, cy + 4), 7, stroke);
    canvas.drawCircle(Offset(cx + 18, cy + 4), 7, stroke);
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + 16), width: 14, height: 14), stroke);
    canvas.drawCircle(Offset(cx - 12, cy - 14), 6, stroke);
    canvas.drawCircle(Offset(cx + 12, cy - 14), 6, stroke);
  }

  void _drawLion(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Fluffy Mane
    canvas.drawCircle(Offset(cx, cy), 46, stroke);
    for (int i = 0; i < 8; i++) {
      final double rad = i * 3.14159 / 4;
      canvas.drawCircle(Offset(cx + 40 * (i % 2 == 0 ? 1 : -1), cy + 40 * (i > 3 ? 1 : -1)), 10, stroke);
    }
    // Face
    canvas.drawCircle(Offset(cx, cy), 28, stroke);
    // Eyes & Nose
    canvas.drawCircle(Offset(cx - 9, cy - 6), 3, fill);
    canvas.drawCircle(Offset(cx + 9, cy - 6), 3, fill);
    canvas.drawPath(Path()..moveTo(cx - 5, cy + 4)..lineTo(cx + 5, cy + 4)..lineTo(cx, cy + 9)..close(), fill);
    // Muzzle
    canvas.drawPath(Path()..moveTo(cx - 10, cy + 14)..quadraticBezierTo(cx, cy + 18, cx + 10, cy + 14), stroke);
  }

  void _drawElephant(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Head & Body
    canvas.drawCircle(Offset(cx, cy - 10), 30, stroke);
    // Large Ears
    canvas.drawPath(Path()..moveTo(cx - 24, cy - 25)..cubicTo(cx - 56, cy - 30, cx - 52, cy + 10, cx - 20, cy), stroke);
    canvas.drawPath(Path()..moveTo(cx + 24, cy - 25)..cubicTo(cx + 56, cy - 30, cx + 52, cy + 10, cx + 20, cy), stroke);
    // Trunk
    final trunk = Path()
      ..moveTo(cx - 8, cy + 4)
      ..cubicTo(cx - 8, cy + 36, cx + 22, cy + 44, cx + 20, cy + 24);
    canvas.drawPath(trunk, stroke);
    // Eyes
    canvas.drawCircle(Offset(cx - 10, cy - 12), 3, fill);
    canvas.drawCircle(Offset(cx + 10, cy - 12), 3, fill);
  }

  void _drawMonkey(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(cx, cy), 32, stroke);
    canvas.drawCircle(Offset(cx - 34, cy), 12, stroke);
    canvas.drawCircle(Offset(cx + 34, cy), 12, stroke);
    // Eyes
    canvas.drawCircle(Offset(cx - 10, cy - 6), 3, fill);
    canvas.drawCircle(Offset(cx + 10, cy - 6), 3, fill);
    // Big smile
    canvas.drawPath(Path()..moveTo(cx - 16, cy + 8)..quadraticBezierTo(cx, cy + 22, cx + 16, cy + 8), stroke);
  }

  void _drawTiger(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(cx, cy), 34, stroke);
    canvas.drawCircle(Offset(cx - 26, cy - 26), 10, stroke);
    canvas.drawCircle(Offset(cx + 26, cy - 26), 10, stroke);
    canvas.drawCircle(Offset(cx - 10, cy - 4), 3, fill);
    canvas.drawCircle(Offset(cx + 10, cy - 4), 3, fill);
    // Stripes
    canvas.drawLine(Offset(cx - 30, cy), Offset(cx - 18, cy), stroke);
    canvas.drawLine(Offset(cx + 30, cy), Offset(cx + 18, cy), stroke);
    canvas.drawLine(Offset(cx, cy - 30), Offset(cx, cy - 18), stroke);
  }

  void _drawGiraffe(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(cx, cy - 24), 22, stroke);
    canvas.drawLine(Offset(cx - 10, cy - 4), Offset(cx - 14, cy + 48), stroke);
    canvas.drawLine(Offset(cx + 10, cy - 4), Offset(cx + 14, cy + 48), stroke);
    canvas.drawCircle(Offset(cx - 7, cy - 24), 2.5, fill);
    canvas.drawCircle(Offset(cx + 7, cy - 24), 2.5, fill);
    // Horns
    canvas.drawLine(Offset(cx - 8, cy - 44), Offset(cx - 8, cy - 58), stroke);
    canvas.drawCircle(Offset(cx - 8, cy - 58), 3, stroke);
    canvas.drawLine(Offset(cx + 8, cy - 44), Offset(cx + 8, cy - 58), stroke);
    canvas.drawCircle(Offset(cx + 8, cy - 58), 3, stroke);
  }

  void _drawBarn(Canvas canvas, double cx, double cy, Paint stroke) {
    // Barn shape
    final barn = Path()
      ..moveTo(cx - 38, cy + 34)
      ..lineTo(cx - 38, cy)
      ..lineTo(cx - 22, cy - 26)
      ..lineTo(cx, cy - 42)
      ..lineTo(cx + 22, cy - 26)
      ..lineTo(cx + 38, cy)
      ..lineTo(cx + 38, cy + 34)
      ..close();
    canvas.drawPath(barn, stroke);
    // Door with X
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + 14), width: 28, height: 38), stroke);
    canvas.drawLine(Offset(cx - 14, cy - 5), Offset(cx + 14, cy + 33), stroke);
    canvas.drawLine(Offset(cx + 14, cy - 5), Offset(cx - 14, cy + 33), stroke);
  }

  void _drawCow(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(cx, cy - 10), 28, stroke);
    // Snout
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 6), width: 34, height: 20), const Radius.circular(10)), stroke);
    canvas.drawCircle(Offset(cx - 6, cy + 6), 2.5, fill);
    canvas.drawCircle(Offset(cx + 6, cy + 6), 2.5, fill);
    // Eyes & Horns
    canvas.drawCircle(Offset(cx - 10, cy - 16), 3, fill);
    canvas.drawCircle(Offset(cx + 10, cy - 16), 3, fill);
    canvas.drawPath(Path()..moveTo(cx - 18, cy - 32)..lineTo(cx - 26, cy - 46)..lineTo(cx - 10, cy - 36), stroke);
    canvas.drawPath(Path()..moveTo(cx + 18, cy - 32)..lineTo(cx + 26, cy - 46)..lineTo(cx + 10, cy - 36), stroke);
  }

  void _drawRooster(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(cx - 10, cy - 12), 22, stroke);
    // Comb
    canvas.drawPath(Path()..moveTo(cx - 18, cy - 32)..quadraticBezierTo(cx - 10, cy - 48, cx, cy - 32), stroke);
    // Beak
    canvas.drawPath(Path()..moveTo(cx - 28, cy - 14)..lineTo(cx - 44, cy - 8)..lineTo(cx - 28, cy - 4)..close(), stroke);
    // Eye
    canvas.drawCircle(Offset(cx - 16, cy - 16), 3, fill);
  }

  void _drawSheep(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Fluffy cloud body
    for (int i = 0; i < 7; i++) {
      final double ang = i * 3.14159 / 3.5;
      canvas.drawCircle(Offset(cx + 28 * math.cos(ang), cy + 24 * math.sin(ang)), 14, stroke);
    }
    // Face
    canvas.drawCircle(Offset(cx, cy), 18, stroke);
    canvas.drawCircle(Offset(cx - 6, cy - 4), 2.5, fill);
    canvas.drawCircle(Offset(cx + 6, cy - 4), 2.5, fill);
  }

  void _drawHorse(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    final head = Path()
      ..moveTo(cx - 10, cy + 34)
      ..lineTo(cx - 30, cy + 18)
      ..lineTo(cx - 22, cy - 24)
      ..lineTo(cx, cy - 40)
      ..lineTo(cx + 18, cy - 10)
      ..lineTo(cx + 18, cy + 34)
      ..close();
    canvas.drawPath(head, stroke);
    canvas.drawCircle(Offset(cx - 8, cy - 16), 3, fill);
    canvas.drawPath(Path()..moveTo(cx + 4, cy - 40)..lineTo(cx + 8, cy - 54)..lineTo(cx + 16, cy - 36), stroke);
  }

  void _drawApple(Canvas canvas, double cx, double cy, Paint stroke) {
    final apple = Path()
      ..moveTo(cx, cy - 22)
      ..cubicTo(cx - 44, cy - 44, cx - 52, cy + 24, cx, cy + 44)
      ..cubicTo(cx + 52, cy + 24, cx + 44, cy - 44, cx, cy - 22);
    canvas.drawPath(apple, stroke);
    // Stem
    canvas.drawPath(Path()..moveTo(cx, cy - 22)..quadraticBezierTo(cx + 6, cy - 44, cx + 16, cy - 46), stroke);
    // Leaf
    final leaf = Path()
      ..moveTo(cx + 6, cy - 36)
      ..quadraticBezierTo(cx + 26, cy - 50, cx + 34, cy - 34)
      ..quadraticBezierTo(cx + 18, cy - 28, cx + 6, cy - 36);
    canvas.drawPath(leaf, stroke);
  }

  void _drawBanana(Canvas canvas, double cx, double cy, Paint stroke) {
    final banana = Path()
      ..moveTo(cx - 34, cy - 36)
      ..cubicTo(cx - 10, cy + 44, cx + 38, cy + 36, cx + 44, cy - 8)
      ..cubicTo(cx + 28, cy + 20, cx - 4, cy + 26, cx - 34, cy - 36);
    canvas.drawPath(banana, stroke);
  }

  void _drawCarrot(Canvas canvas, double cx, double cy, Paint stroke) {
    final carrot = Path()
      ..moveTo(cx - 20, cy - 18)
      ..quadraticBezierTo(cx, cy + 50, cx, cy + 52)
      ..quadraticBezierTo(cx + 10, cy + 20, cx + 20, cy - 18)
      ..close();
    canvas.drawPath(carrot, stroke);
    // Leaves at top
    canvas.drawLine(Offset(cx, cy - 18), Offset(cx, cy - 48), stroke);
    canvas.drawLine(Offset(cx - 6, cy - 18), Offset(cx - 22, cy - 42), stroke);
    canvas.drawLine(Offset(cx + 6, cy - 18), Offset(cx + 22, cy - 42), stroke);
  }

  void _drawWatermelon(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    final slice = Path()
      ..moveTo(cx - 44, cy - 10)
      ..quadraticBezierTo(cx, cy + 50, cx + 44, cy - 10)
      ..close();
    canvas.drawPath(slice, stroke);
    canvas.drawCircle(Offset(cx - 18, cy + 8), 2.5, fill);
    canvas.drawCircle(Offset(cx, cy + 18), 2.5, fill);
    canvas.drawCircle(Offset(cx + 18, cy + 8), 2.5, fill);
  }

  void _drawDolphin(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    final dolphin = Path()
      ..moveTo(cx - 44, cy + 14)
      ..cubicTo(cx - 34, cy - 36, cx + 18, cy - 38, cx + 46, cy - 4)
      ..cubicTo(cx + 34, cy + 8, cx + 10, cy + 12, cx - 18, cy + 4)
      ..lineTo(cx - 44, cy + 14);
    canvas.drawPath(dolphin, stroke);
    // Dorsal Fin
    canvas.drawPath(Path()..moveTo(cx - 4, cy - 32)..lineTo(cx + 8, cy - 48)..lineTo(cx + 12, cy - 30), stroke);
    // Eye
    canvas.drawCircle(Offset(cx + 34, cy - 12), 2.5, fill);
  }

  void _drawSeaTurtle(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    // Shell
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 56, height: 44), stroke);
    // Flippers
    canvas.drawCircle(Offset(cx + 32, cy), 10, stroke); // Head
    canvas.drawCircle(Offset(cx + 34, cy - 4), 2, fill);
    canvas.drawPath(Path()..moveTo(cx + 16, cy - 18)..lineTo(cx + 34, cy - 36)..lineTo(cx + 6, cy - 22), stroke);
    canvas.drawPath(Path()..moveTo(cx + 16, cy + 18)..lineTo(cx + 34, cy + 36)..lineTo(cx + 6, cy + 22), stroke);
  }

  void _drawWhale(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    final whale = Path()
      ..moveTo(cx - 44, cy - 14)
      ..cubicTo(cx - 10, cy - 34, cx + 34, cy - 28, cx + 44, cy)
      ..cubicTo(cx + 34, cy + 30, cx - 20, cy + 30, cx - 44, cy - 14);
    canvas.drawPath(whale, stroke);
    canvas.drawCircle(Offset(cx + 32, cy - 4), 3, fill);
    // Spout
    canvas.drawPath(Path()..moveTo(cx + 10, cy - 28)..lineTo(cx + 10, cy - 48)..lineTo(cx + 4, cy - 54), stroke);
    canvas.drawPath(Path()..moveTo(cx + 10, cy - 44)..lineTo(cx + 18, cy - 52), stroke);
  }

  void _drawOctopus(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(cx, cy - 14), 28, stroke);
    canvas.drawCircle(Offset(cx - 9, cy - 14), 3, fill);
    canvas.drawCircle(Offset(cx + 9, cy - 14), 3, fill);
    // Tentacles
    for (int i = 0; i < 5; i++) {
      final double tx = cx - 24 + i * 12;
      canvas.drawPath(Path()..moveTo(tx, cy + 12)..quadraticBezierTo(tx + (i % 2 == 0 ? 8 : -8), cy + 42, tx, cy + 48), stroke);
    }
  }

  void _drawMagicStar(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    final star = Path();
    for (int i = 0; i < 5; i++) {
      final double rOuter = 40;
      final double rInner = 18;
      final double a1 = (i * 72 - 18) * 3.14159 / 180;
      final double a2 = (i * 72 + 18) * 3.14159 / 180;
      if (i == 0) {
        star.moveTo(cx + rOuter * math.cos(a1), cy + rOuter * math.sin(a1));
      } else {
        star.lineTo(cx + rOuter * math.cos(a1), cy + rOuter * math.sin(a1));
      }
      star.lineTo(cx + rInner * math.cos(a2), cy + rInner * math.sin(a2));
    }
    star.close();
    canvas.drawPath(star, stroke);
    canvas.drawCircle(Offset(cx - 8, cy - 2), 2.5, fill);
    canvas.drawCircle(Offset(cx + 8, cy - 2), 2.5, fill);
  }

  void _drawDragon(Canvas canvas, double cx, double cy, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(cx, cy - 12), 24, stroke);
    canvas.drawCircle(Offset(cx - 8, cy - 14), 2.5, fill);
    canvas.drawCircle(Offset(cx + 8, cy - 14), 2.5, fill);
    // Tiny horns
    canvas.drawPath(Path()..moveTo(cx - 12, cy - 34)..lineTo(cx - 18, cy - 48)..lineTo(cx - 6, cy - 36), stroke);
    canvas.drawPath(Path()..moveTo(cx + 12, cy - 34)..lineTo(cx + 18, cy - 48)..lineTo(cx + 6, cy - 36), stroke);
    // Wings
    canvas.drawPath(Path()..moveTo(cx - 20, cy)..lineTo(cx - 44, cy - 18)..lineTo(cx - 24, cy + 16), stroke);
    canvas.drawPath(Path()..moveTo(cx + 20, cy)..lineTo(cx + 44, cy - 18)..lineTo(cx + 24, cy + 16), stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
