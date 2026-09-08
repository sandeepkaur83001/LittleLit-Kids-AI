import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/child_profiles_screen.dart';
import 'package:little_kids_ai/features/game/music_settings_screen.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              children: [
                _buildSettingItem(
                  'Account',
                  'Add and Edit child',
                  iconAsset: 'assets/images/src_assets_icons_child_profile_icon.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChildProfilesScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  'Music',
                  'Music credits & volume',
                  iconAsset: 'assets/images/src_assets_icons_music_icon.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MusicSettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  'Delete Account',
                  'Delete your account permanently',
                  iconAsset: 'assets/images/src_assets_icons_delete_icon.png',
                ),
                _buildSettingItem(
                  'Share',
                  'Share app by link',
                  iconAsset: 'assets/images/src_assets_icons_share_icon.png',
                ),
                _buildSettingItem(
                  'Upgrade',
                  'Upgrade your account',
                  iconAsset: 'assets/images/src_assets_icons_60_discount.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.blue.shade100.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
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
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              'User: akashakash22558800@gmail.com',
              style: GoogleFonts.comicNeue(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Image.asset(
            'assets/images/src_assets_icons_btn_logout.png',
            width: 34,
            height: 34,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.power_settings_new, color: Colors.blue, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, {String? iconAsset, VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            if (iconAsset != null) ...[
              Image.asset(
                iconAsset,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.comicNeue(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.comicNeue(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
