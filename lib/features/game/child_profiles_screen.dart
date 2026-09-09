import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';
import 'package:little_kids_ai/features/game/edit_child_profile_screen.dart';

class ChildProfilesScreen extends StatefulWidget {
  const ChildProfilesScreen({super.key});

  @override
  State<ChildProfilesScreen> createState() => _ChildProfilesScreenState();
}

class _ChildProfilesScreenState extends State<ChildProfilesScreen> {
  final List<Map<String, dynamic>> _profiles = [
    {
      'name': 'Test',
      'age': '14',
      'grade': 'Grade 4',
      'neurodivergent': false,
    },
  ];

  void _openEditProfileScreen({int? index}) async {
    final bool isEditing = index != null;
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditChildProfileScreen(
          initialName: isEditing ? (_profiles[index]['name'] ?? '') : '',
          initialAge: isEditing ? (_profiles[index]['age']?.toString() ?? '') : '',
          initialGrade: isEditing ? (_profiles[index]['grade'] ?? 'Grade 4') : 'Grade 4',
          initialNeurodivergent: isEditing ? (_profiles[index]['neurodivergent'] ?? false) : false,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        if (isEditing) {
          _profiles[index] = result;
        } else {
          _profiles.add(result);
        }
      });
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ..._profiles.asMap().entries.map((entry) {
                          final index = entry.key;
                          final profile = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: _buildProfileCard(
                              name: profile['name'] ?? '',
                              age: profile['age']?.toString() ?? '',
                              onEdit: () => _openEditProfileScreen(index: index),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        _buildAddChildButton(),
                      ],
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
          if (_profiles.isNotEmpty) {
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
