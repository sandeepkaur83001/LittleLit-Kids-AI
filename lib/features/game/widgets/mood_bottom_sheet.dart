import 'package:flutter/material.dart';
import 'package:little_kids_ai/core/common_imports.dart';

class MoodBottomSheet extends StatefulWidget {
  const MoodBottomSheet({super.key});

  @override
  State<MoodBottomSheet> createState() => _MoodBottomSheetState();
}

class _MoodBottomSheetState extends State<MoodBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController _zoomController;
  int? _selectedMoodIndex;

  final List<Map<String, dynamic>> _moods = const [
    {'label': 'EXCITED', 'image': 'assets/images/excited.png', 'rotation': -0.22},
    {'label': 'HAPPY', 'image': 'assets/images/happy.png', 'rotation': 0.0},
    {'label': 'SILLY', 'image': 'assets/images/silly.png', 'rotation': 0.0},
    {'label': 'TIRED', 'image': 'assets/images/tired.png', 'rotation': 0.0},
    {'label': 'SAD', 'image': 'assets/images/sad.png', 'rotation': 0.0},
    {'label': 'ANXIOUS', 'image': 'assets/images/anxious.png', 'rotation': 0.0},
  ];

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  void _onMoodSelected(int index) {
    setState(() {
      _selectedMoodIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        image: const DecorationImage(
          image: AssetImage('assets/images/src_assets_images_mood_back.png'),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          opacity: 0.95,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Top Drag Handle
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Header Banner Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Groovy time! Pick how do you feel and let's play some music that'll make you smile",
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 6 Mood Emotion Characters Row across Full Width
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(_moods.length, (index) {
                  return _buildMoodItem(index);
                }),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodItem(int index) {
    final mood = _moods[index];
    final bool isSelected = _selectedMoodIndex == index;
    final bool hasSelection = _selectedMoodIndex != null;
    final double itemOpacity = hasSelection ? (isSelected ? 1.0 : 0.35) : 1.0;
    final double rotation = (mood['rotation'] as double?) ?? 0.0;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onMoodSelected(index),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          opacity: itemOpacity,
          child: AnimatedBuilder(
            animation: _zoomController,
            builder: (context, child) {
              // Staggered pulsing zoom in/out effect
              final double pulseOffset = (index * 0.25) % 1.0;
              final double progress = (_zoomController.value + pulseOffset) % 1.0;
              final double idleScale = 0.94 + (0.08 * (1.0 - (progress - 0.5).abs() * 2.0));
              final double scale = isSelected ? 1.15 : (hasSelection ? 0.92 : idleScale);

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Emotion Label with dynamic tilt/rotation
                  Transform.rotate(
                    angle: rotation,
                    child: Text(
                      mood['label'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Character Image with compact height & zoom animation
                  Transform.scale(
                    scale: scale,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 86,
                      child: Image.asset(
                        mood['image'] as String,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.music_note, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
