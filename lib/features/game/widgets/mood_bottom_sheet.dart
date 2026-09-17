import 'package:get/get.dart';
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
    {'id': 1, 'label': 'EXCITED', 'image': 'assets/images/excited.png', 'rotation': -0.22},
    {'id': 2, 'label': 'HAPPY', 'image': 'assets/images/happy.png', 'rotation': 0.0},
    {'id': 3, 'label': 'SILLY', 'image': 'assets/images/silly.png', 'rotation': 0.0},
    {'id': 4, 'label': 'TIRED', 'image': 'assets/images/tired.png', 'rotation': 0.0},
    {'id': 5, 'label': 'SAD', 'image': 'assets/images/sad.png', 'rotation': 0.0},
    {'id': 6, 'label': 'ANXIOUS', 'image': 'assets/images/anxious.png', 'rotation': 0.0},
  ];

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _initSelectedMood();
  }

  void _initSelectedMood() {
    final profileController = Get.find<ProfileController>();
    profileController.fetchMoods();
    final currentMoodId = profileController.userProfile.value?.moodId ??
        profileController.selectedMood.value?.id;
    if (currentMoodId != null && currentMoodId >= 1 && currentMoodId <= 6) {
      _selectedMoodIndex = currentMoodId - 1;
    }
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

    final moodId = (_moods[index]['id'] as int?) ?? (index + 1);
    final profileController = Get.find<ProfileController>();
    if (profileController.moodList.isNotEmpty) {
      final matched = profileController.moodList.firstWhereOrNull((m) => m.id == moodId);
      if (matched != null) {
        profileController.selectedMood.value = matched;
      }
    }
    profileController.updateProfile(
      moodId: moodId,
      showLoading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Top White Strip with Only the Drag Handle
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Mood Background Area with Header Text and Characters
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/src_assets_images_mood_back.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Column(
                children: [
                  // Header Title Text on Mood Background
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Groovy time! Pick how do you feel and let's play some music that'll make you smile",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  // const Spacer(),
                  const SizedBox(height: 40),

                  // 6 Mood Emotion Characters Row
                  Obx(() {
                    final profileController = Get.find<ProfileController>();
                    final apiMoods = profileController.moodList;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(_moods.length, (index) {
                        final fallbackMood = _moods[index];
                        final moodId = (fallbackMood['id'] as int?) ?? (index + 1);
                        final MoodModel? apiMood = apiMoods.firstWhereOrNull((m) => m.id == moodId);

                        return _buildMoodItem(index, fallbackMood, apiMood);
                      }),
                    );
                  }),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodItem(int index, Map<String, dynamic> fallbackMood, MoodModel? apiMood) {
    final bool isSelected = _selectedMoodIndex == index;
    final bool hasSelection = _selectedMoodIndex != null;
    final double itemOpacity = hasSelection ? (isSelected ? 1.0 : 0.35) : 1.0;
    final String? iconUrl = apiMood?.iconUrl;
    final String fallbackAsset = fallbackMood['image'] as String;

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
              final double bounceFactor = 1.0 - (progress - 0.5).abs() * 2.0;
              final double scale = isSelected
                  ? 1.10 + (0.12 * bounceFactor) // Selected character continues to pop up and pulse actively
                  : (hasSelection
                      ? 0.90 + (0.05 * bounceFactor) // Other characters continue subtle breathing
                      : 0.94 + (0.08 * bounceFactor)); // Default idle breathing

              return Transform.scale(
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Character Image with increased height (API network image with local fallback)
                    SizedBox(
                      height: 96,
                      child: (iconUrl != null && iconUrl.isNotEmpty)
                          ? Image.network(
                              iconUrl,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                fallbackAsset,
                                fit: BoxFit.contain,
                                alignment: Alignment.bottomCenter,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 80,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.music_note, color: Colors.white, size: 28),
                                ),
                              ),
                            )
                          : Image.asset(
                              fallbackAsset,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 80,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.music_note, color: Colors.white, size: 28),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
