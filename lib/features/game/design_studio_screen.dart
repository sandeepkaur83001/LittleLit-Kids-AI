import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/design_apparel_selection_screen.dart';
import 'package:little_kids_ai/features/game/magic_art_screen.dart';

class PlacedPatch {
  Offset position;
  final Widget widget;
  final String label;

  PlacedPatch({required this.position, required this.widget, required this.label});
}

class DesignStudioScreen extends StatefulWidget {
  final ApparelItem item;

  const DesignStudioScreen({super.key, required this.item});

  @override
  State<DesignStudioScreen> createState() => _DesignStudioScreenState();
}

class _DesignStudioScreenState extends State<DesignStudioScreen> {
  int _selectedTabIndex = 0; // 0: PATCH, 1: STICKER, 2: MAGIC ART, 3: TEXT
  final List<PlacedPatch> _placedPatches = [];

  final List<Map<String, dynamic>> _patches = [
    {
      'label': 'Be Kind',
      'color': const Color(0xFF38BDF8),
      'icon': Icons.sentiment_satisfied_alt_rounded,
      'isCircle': true,
    },
    {
      'label': 'Cupcake',
      'color': const Color(0xFFF472B6),
      'icon': Icons.cake_rounded,
      'isCircle': false,
    },
    {
      'label': 'Yellow Fabric',
      'color': const Color(0xFFEAB308),
      'icon': Icons.texture_rounded,
      'isSquare': true,
    },
    {
      'label': 'Orange Fabric',
      'color': const Color(0xFFFB923C),
      'icon': Icons.texture_rounded,
      'isSquare': true,
    },
    {
      'label': 'Pink Fabric',
      'color': const Color(0xFFEC4899),
      'icon': Icons.texture_rounded,
      'isSquare': true,
    },
    {
      'label': 'Heart',
      'color': const Color(0xFFEF4444),
      'icon': Icons.favorite_rounded,
      'isHeart': true,
    },
  ];

  final List<Map<String, dynamic>> _stickers = [
    {
      'label': 'Headphones',
      'color': const Color(0xFFA855F7),
      'icon': Icons.headphones_rounded,
    },
    {
      'label': 'Star',
      'color': const Color(0xFFFACC15),
      'icon': Icons.star_rounded,
    },
    {
      'label': 'Rocket',
      'color': const Color(0xFF3B82F6),
      'icon': Icons.rocket_launch_rounded,
    },
    {
      'label': 'Music',
      'color': const Color(0xFF10B981),
      'icon': Icons.music_note_rounded,
    },
  ];

  void _onPatchDropped(Map<String, dynamic> itemData, Offset localPos) {
    setState(() {
      _placedPatches.add(
        PlacedPatch(
          position: localPos,
          label: itemData['label'],
          widget: _buildItemVisual(itemData, size: 54),
        ),
      );
    });
  }

  void _showDoneModal() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Image.asset(
                    'assets/images/src_assets_icons_btn_cross.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.08),
                      ),
                      child: const Icon(Icons.close, color: Colors.black87, size: 20),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Great Creation!',
                    style: GoogleFonts.comicNeue(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Artwork downloaded to gallery! 🎨',
                            style: GoogleFonts.comicNeue(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: const Color(0xFF16A34A),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Download your creation',
                            style: GoogleFonts.comicNeue(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(
                            'assets/images/src_assets_icons_btn_download.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.download_rounded, color: Color(0xFF0F172A), size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Designed by You',
                    style: GoogleFonts.comicNeue(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
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
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: SafeArea(
        child: Stack(
          children: [
            // Center Apparel Canvas
            Center(
              child: _buildApparelDesignCanvas(),
            ),

            // Left Vertical Tool Panel & Drawer
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _buildLeftToolsDrawer(),
            ),

            // Top Left Magic Art Badge
            Positioned(
              top: 10,
              left: 170,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MagicArtScreen()),
                  );
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFEF08A), Color(0xFFFDE047)],
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Make',
                          style: GoogleFonts.comicNeue(fontSize: 8, fontWeight: FontWeight.bold, height: 1.0),
                        ),
                        const Icon(Icons.auto_fix_high_rounded, size: 18, color: Colors.black87),
                        Text(
                          'Magic Art',
                          style: GoogleFonts.comicNeue(fontSize: 7, fontWeight: FontWeight.bold, height: 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Top Right Close Button
            Positioned(
              top: 10,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/images/src_assets_icons_btn_cross.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF80CBC4).withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.black87, size: 24),
                  ),
                ),
              ),
            ),

            // Bottom Right Checkmark Button
            Positioned(
              bottom: 16,
              right: 20,
              child: GestureDetector(
                onTap: _showDoneModal,
                child: Image.asset(
                  'assets/images/src_assets_images_maker_done.png',
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF80CBC4).withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF0F172A),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftToolsDrawer() {
    return Row(
      children: [
        // Tab Content Items Drawer
        Container(
          width: 80,
          color: Colors.white.withOpacity(0.85),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            children: [
              if (_selectedTabIndex == 0)
                ..._patches.map((patch) => _buildDraggableSourceItem(patch))
              else if (_selectedTabIndex == 1)
                ..._stickers.map((sticker) => _buildDraggableSourceItem(sticker))
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      _selectedTabIndex == 2 ? 'Magic\nAI' : 'Text\nStamps',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Vertical Tabs Strip
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildVerticalTab('PATCH', const Color(0xFFE0F2FE), 0),
            _buildVerticalTab('STICKER', const Color(0xFF86EFAC), 1),
            _buildVerticalTab('MAGIC ART', const Color(0xFF93C5FD), 2),
            _buildVerticalTab('TEXT', const Color(0xFFFDE047), 3),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalTab(String label, Color color, int index) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        width: 32,
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(2, 0),
              ),
          ],
        ),
        child: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              label,
              style: GoogleFonts.comicNeue(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableSourceItem(Map<String, dynamic> itemData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Draggable<Map<String, dynamic>>(
        data: itemData,
        feedback: Material(
          color: Colors.transparent,
          child: _buildItemVisual(itemData, size: 60),
        ),
        childWhenDragging: Opacity(
          opacity: 0.4,
          child: _buildItemVisual(itemData, size: 50),
        ),
        child: _buildItemVisual(itemData, size: 50),
      ),
    );
  }

  Widget _buildItemVisual(Map<String, dynamic> itemData, {required double size}) {
    final Color color = itemData['color'] as Color;
    final IconData icon = itemData['icon'] as IconData;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: itemData['isCircle'] == true ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: itemData['isCircle'] == true ? null : BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: size * 0.55),
      ),
    );
  }

  Widget _buildApparelDesignCanvas() {
    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPos = renderBox.globalToLocal(details.offset);
        _onPatchDropped(details.data, localPos);
      },
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: 380,
          height: 380,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Apparel Graphic
              Icon(
                widget.item.isShirt ? Icons.checkroom_rounded : Icons.dry_cleaning_rounded,
                size: 320,
                color: widget.item.color == Colors.white ? Colors.white : widget.item.color,
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              // Placed Patches
              ..._placedPatches.asMap().entries.map((entry) {
                final int idx = entry.key;
                final PlacedPatch patch = entry.value;

                return Positioned(
                  left: patch.position.dx.clamp(40.0, 300.0),
                  top: patch.position.dy.clamp(40.0, 300.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      patch.widget,
                      // Delete badge on patch
                      Positioned(
                        top: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _placedPatches.removeAt(idx));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete_rounded, color: Colors.white, size: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
