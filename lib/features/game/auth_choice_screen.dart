import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/auth/widgets/sign_in_dialog.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/profile_setup_screen.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GameBackground(
      backgroundImage: 'assets/images/src_assets_background_splash_back.png',
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0F58E), // Light lime green
                  Color(0xFF8FE6E1), // Light cyan/blue
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Let's set up a child profile",
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() => _buildAuthButton(
                  iconPath: 'assets/images/src_assets_images_google.png',
                  text: authController.isLoading.value ? 'Signing in...' : 'Sign up with Google',
                  onTap: () {
                    if (!authController.isLoading.value) {
                      authController.signInWithGoogle(context: context);
                    }
                  },
                  isGoogle: true,
                )),
                const SizedBox(height: 15),
                _buildAuthButton(
                  iconPath: 'assets/images/src_assets_images_email.png',
                  text: 'Sign up with Email',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                    );
                  },
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () => SignInDialog.show(context),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.comicNeue(
                        color: const Color(0xFF555555),
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
    bool isGoogle = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 35,
              width: 35,
              errorBuilder: (context, error, stackTrace) => Icon(
                isGoogle ? Icons.g_mobiledata : Icons.email,
                color: Colors.blue,
                size: 35,
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.comicNeue(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF444444),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
