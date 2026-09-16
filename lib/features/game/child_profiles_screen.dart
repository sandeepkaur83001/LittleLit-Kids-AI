import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';
import 'package:little_kids_ai/features/game/edit_child_profile_screen.dart';
import 'package:little_kids_ai/features/profile/controllers/profile_controller.dart';

class ChildProfilesScreen extends StatefulWidget {
  const ChildProfilesScreen({super.key});

  @override
  State<ChildProfilesScreen> createState() => _ChildProfilesScreenState();
}

class _ChildProfilesScreenState extends State<ChildProfilesScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfile();
  }

  void _openEditProfileScreen({ChildModel? child}) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditChildProfileScreen(
          childId: child?.id,
          initialName: child?.nickname ?? _profileController.userProfile.value?.childNickname ?? 'Child',
          initialAge: (child?.age ?? _profileController.userProfile.value?.childAge ?? 10).toString(),
          initialGrade: child?.grade ?? _profileController.userProfile.value?.childGrade ?? 'Grade 4',
          initialNeurodivergent: child?.isNeurodivergent ?? _profileController.userProfile.value?.isNeurodivergent ?? false,
        ),
      ),
    );

    if (result != null && mounted) {
      _profileController.fetchProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/landscape_background_clean.png',
      showBackButton: true,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header Title
            Center(
              child: Text(
                'Child Profiles',
                style: GoogleFonts.comicNeue(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 36),
            // Profiles Container & Add Button
            Expanded(
              child: Obx(() {
                final user = _profileController.userProfile.value;
                final List<ChildModel> children = [];
                if (user?.children != null && user!.children!.isNotEmpty) {
                  children.addAll(user.children!);
                } else if (user?.child != null) {
                  children.add(user!.child!);
                } else if (user?.childNickname != null) {
                  children.add(ChildModel(
                    nickname: user!.childNickname,
                    age: user.childAge,
                    grade: user.childGrade,
                    isNeurodivergent: user.isNeurodivergent,
                  ));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 540),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (children.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "No child profiles found.",
                                style: GoogleFonts.comicNeue(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          else
                            ...children.map((child) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: _buildProfileCard(
                                  name: child.nickname ?? 'Child',
                                  age: (child.age ?? 10).toString(),
                                  onEdit: () => _openEditProfileScreen(child: child),
                                ),
                              );
                            }),
                          const SizedBox(height: 8),
                          _buildAddChildButton(),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String name,
    required String age,
    required VoidCallback onEdit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF60A5FA).withOpacity(0.85),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.comicNeue(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Name: '),
                    TextSpan(
                      text: name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.comicNeue(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Age: '),
                    TextSpan(
                      text: age,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withOpacity(0.65),
                  width: 1.2,
                ),
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildButton() {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E78C7),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        ),
        onPressed: () {
          final user = _profileController.userProfile.value;
          final hasChildren = (user?.children != null && user!.children!.isNotEmpty) || (user?.child != null);
          if (hasChildren) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SubscriptionScreen(),
              ),
            );
          } else {
            _openEditProfileScreen();
          }
        },
        child: Text(
          'Add Child',
          style: GoogleFonts.comicNeue(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
