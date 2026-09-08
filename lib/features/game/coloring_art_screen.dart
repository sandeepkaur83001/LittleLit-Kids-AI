import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class DrawnLine {
  final List<Offset> path;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  DrawnLine({
    required this.path,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });
}

class ColoringArtScreen extends StatefulWidget {
  final String? templateImage;
  final String? templateTitle;

  const ColoringArtScreen({
    super.key,
    this.templateImage,
    this.templateTitle,
  });

  @override
  State<ColoringArtScreen> createState() => _ColoringArtScreenState();
}

class _ColoringArtScreenState extends State<ColoringArtScreen> {
  final List<DrawnLine> _lines = [];
  final List<DrawnLine> _redoLines = [];

  Color _selectedColor = const Color(0xFFF85646); // Default Red
  double _strokeWidth = 8.0;
  bool _isEraser = false;
  bool _isBucket = false;
  int _selectedTemplateIndex = 0;

  final List<Map<String, dynamic>> _colorPins = [
    {'color': const Color(0xFF000000), 'image': 'assets/images/src_assets_images_pin_black.png', 'name': 'Black'},
    {'color': const Color(0xFFF85646), 'image': 'assets/images/src_assets_images_pin_red_f85646.png', 'name': 'Red'},
    {'color': const Color(0xFFFF8210), 'image': 'assets/images/src_assets_images_pin_orange_ff8210.png', 'name': 'Orange'},
    {'color': const Color(0xFFFFEB5B), 'image': 'assets/images/src_assets_images_pin_yellow_ffeb5b.png', 'name': 'Yellow'},
    {'color': const Color(0xFF6AD068), 'image': 'assets/images/src_assets_images_pin_green_6ad068.png', 'name': 'Green'},
    {'color': const Color(0xFF348D73), 'image': 'assets/images/src_assets_images_pin_dark_green_348d73.png', 'name': 'Dark Green'},
    {'color': const Color(0xFFAFE2FF), 'image': 'assets/images/src_assets_images_pin_light_blue_afe2ff.png', 'name': 'Light Blue'},
    {'color': const Color(0xFF56AEFF), 'image': 'assets/images/src_assets_images_pin_blue_56aeff.png', 'name': 'Blue'},
    {'color': const Color(0xFFA591EF), 'image': 'assets/images/src_assets_images_pin_purple_a591ef.png', 'name': 'Purple'},
    {'color': const Color(0xFFFFA0DC), 'image': 'assets/images/src_assets_images_pin_pink_ffa0dc.png', 'name': 'Pink'},
    {'color': const Color(0xFF8F5D46), 'image': 'assets/images/src_assets_images_pin_brown_8f5d46.png', 'name': 'Brown'},
    {'color': const Color(0xFFFFFFFF), 'image': 'assets/images/src_assets_images_pin_white.png', 'name': 'White'},
  ];

  late List<String> _templates;

  @override
  void initState() {
    super.initState();
    _templates = [
      if (widget.templateImage != null) widget.templateImage!,
      'assets/images/coloring_arts.png',
      'assets/images/chameleon.png',
      'assets/images/duck_singer.png',
      'assets/images/litto.png',
    ];
  }

  void _undo() {
    if (_lines.isNotEmpty) {
      setState(() {
        _redoLines.add(_lines.removeLast());
      });
    }
  }

  void _redo() {
    if (_redoLines.isNotEmpty) {
      setState(() {
        _lines.add(_redoLines.removeLast());
      });
    }
  }

  void _clearCanvas() {
    setState(() {
      _lines.clear();
      _redoLines.clear();
    });
  }

  void _saveDrawing() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/src_assets_images_great_job.png',
                height: 80,
                errorBuilder: (_, __, ___) => const Icon(Icons.star_rounded, size: 70, color: Color(0xFFFFB800)),
              ),
              const SizedBox(height: 12),
              Text(
                'Masterpiece Saved!',
                style: GoogleFonts.comicNeue(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
              ),
              const SizedBox(height: 6),
              Text(
                'Your art has been added to My Stuff portfolio.',
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E78C7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: Text('Awesome!', style: GoogleFonts.comicNeue(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/landscape_background_clean.png',
      child: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    // Left Tool Panel (Brushes, Eraser, Width, Templates)
                    _buildLeftToolPanel(),
                    const SizedBox(width: 12),

                    // Center Interactive Drawing Canvas
                    Expanded(
                      child: _buildDrawingCanvas(),
                    ),
                    const SizedBox(width: 12),

                    // Right Color Palette (Color Pins)
                    _buildColorPinPalette(),
                  ],
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
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

          // Title
          Text(
            'Coloring & Drawing Art',
            style: GoogleFonts.comicNeue(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),

          // Action Buttons (Undo, Redo, Clear, Save)
          Row(
            children: [
              _buildTopActionButton(
                icon: Icons.undo_rounded,
                imageAsset: 'assets/images/src_assets_icons_btn_reload.png',
                tooltip: 'Undo',
                onTap: _undo,
              ),
              const SizedBox(width: 8),
              _buildTopActionButton(
                icon: Icons.redo_rounded,
                tooltip: 'Redo',
                onTap: _redo,
              ),
              const SizedBox(width: 8),
              _buildTopActionButton(
                icon: Icons.delete_outline_rounded,
                imageAsset: 'assets/images/src_assets_icons_delete_icon.png',
                tooltip: 'Clear',
                onTap: _clearCanvas,
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _saveDrawing,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E78C7),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/src_assets_icons_btn_tick.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Done',
                        style: GoogleFonts.comicNeue(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopActionButton({
    IconData? icon,
    String? imageAsset,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: imageAsset != null
            ? Image.asset(
                imageAsset,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              )
            : Icon(
                icon,
                size: 20,
                color: const Color(0xFF1E293B),
              ),
      ),
    );
  }

  Widget _buildLeftToolPanel() {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Pen / Brush Tool
            _buildToolIcon(
              icon: Icons.brush_rounded,
              label: 'Brush',
              isSelected: !_isEraser && !_isBucket && _strokeWidth == 8.0,
              onTap: () => setState(() {
                _isEraser = false;
                _isBucket = false;
                _strokeWidth = 8.0;
              }),
            ),
            const SizedBox(height: 6),

            // Bucket Tool (Fill)
            _buildToolIcon(
              icon: Icons.format_color_fill_rounded,
              label: 'Bucket',
              isSelected: _isBucket,
              onTap: () => setState(() {
                _isBucket = true;
                _isEraser = false;
              }),
            ),
            const SizedBox(height: 6),

            // Thick Marker
            _buildToolIcon(
              icon: Icons.format_paint_rounded,
              label: 'Marker',
              isSelected: !_isEraser && !_isBucket && _strokeWidth == 18.0,
              onTap: () => setState(() {
                _isEraser = false;
                _isBucket = false;
                _strokeWidth = 18.0;
              }),
            ),
            const SizedBox(height: 6),

            // Thin Pen
            _buildToolIcon(
              icon: Icons.edit_rounded,
              label: 'Pencil',
              isSelected: !_isEraser && !_isBucket && _strokeWidth == 3.0,
              onTap: () => setState(() {
                _isEraser = false;
                _isBucket = false;
                _strokeWidth = 3.0;
              }),
            ),
            const SizedBox(height: 6),

            // Eraser Tool
            _buildToolIcon(
              icon: Icons.auto_fix_normal_rounded,
              label: 'Eraser',
              isSelected: _isEraser,
              onTap: () => setState(() {
                _isEraser = true;
                _isBucket = false;
              }),
            ),
            const Divider(height: 14, color: Colors.black12),

            // Template Switcher Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTemplateIndex = (_selectedTemplateIndex + 1) % _templates.length;
                  _clearCanvas();
                });
              },
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF60A5FA), width: 1.2),
                    ),
                    child: Image.asset(
                      _templates[_selectedTemplateIndex],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Template',
                    style: GoogleFonts.comicNeue(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolIcon({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E78C7) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.white, width: 1.5) : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.comicNeue(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawingCanvas() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Coloring Template
            Positioned.fill(
              child: Opacity(
                opacity: 0.38,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    _templates[_selectedTemplateIndex],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              ),
            ),

            // Drawing Area Gesture Detector (handles Brush strokes and Bucket fill taps)
            GestureDetector(
              onTapDown: (details) {
                if (_isBucket) {
                  final localPos = details.localPosition;
                  setState(() {
                    _lines.add(DrawnLine(
                      path: [localPos],
                      color: _selectedColor,
                      strokeWidth: 90.0, // Big vibrant color splotch / fill region
                      isEraser: false,
                    ));
                    _redoLines.clear();
                  });
                }
              },
              onPanStart: (details) {
                if (_isBucket) return;
                final localPos = details.localPosition;
                setState(() {
                  _lines.add(DrawnLine(
                    path: [localPos],
                    color: _selectedColor,
                    strokeWidth: _isEraser ? 24.0 : _strokeWidth,
                    isEraser: _isEraser,
                  ));
                  _redoLines.clear();
                });
              },
              onPanUpdate: (details) {
                if (_isBucket) return;
                final localPos = details.localPosition;
                setState(() {
                  if (_lines.isNotEmpty) {
                    _lines.last.path.add(localPos);
                  }
                });
              },
              child: CustomPaint(
                painter: CanvasPainter(lines: _lines),
                size: Size.infinite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPinPalette() {
    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: ListView.builder(
        itemCount: _colorPins.length,
        itemBuilder: (context, index) {
          final pin = _colorPins[index];
          final bool isSelected = _selectedColor == pin['color'] && !_isEraser;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = pin['color'];
                  _isEraser = false;
                });
              },
              child: Transform.scale(
                scale: isSelected ? 1.18 : 1.0,
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: (pin['color'] as Color).withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Image.asset(
                    pin['image'],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        color: pin['color'],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<DrawnLine> lines;

  CanvasPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      if (line.path.isEmpty) continue;

      final paint = Paint()
        ..color = line.isEraser ? Colors.white : line.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke;

      if (line.path.length == 1) {
        canvas.drawCircle(line.path.first, line.strokeWidth / 2, paint..style = PaintingStyle.fill);
      } else {
        final path = Path();
        path.moveTo(line.path.first.dx, line.path.first.dy);

        for (int i = 1; i < line.path.length; i++) {
          path.lineTo(line.path[i].dx, line.path[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) => true;
}
