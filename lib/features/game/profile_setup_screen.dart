import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/auth/controllers/auth_controller.dart';
import 'package:little_kids_ai/features/auth/widgets/sign_in_dialog.dart';
import 'package:little_kids_ai/features/auth/widgets/terms_agreement_dialog.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/widgets/common/app_web_view_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedGrade = 'Grade 4';
  bool _isNeurodivergent = false;
  bool _agreed = false;
  bool _obscurePassword = true;

  final List<String> _gradeOptions = const [
    'Pre-K',
    'Kindergarten',
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
    'Grade 7',
    'Grade 8',
    'Grade 9',
    'Grade 10',
    'Grade 11',
    'Grade 12',
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final nickname = _nicknameController.text.trim();
    final ageStr = _ageController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (nickname.isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter child's nickname");
      return;
    }
    final age = int.tryParse(ageStr);
    if (age == null || age <= 0) {
      CustomToast.showErrorToast(msg: "Please enter a valid age (1-18)");
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      CustomToast.showErrorToast(msg: "Please enter a valid parent email");
      return;
    }
    if (password.length < 6) {
      CustomToast.showErrorToast(msg: "Password must be at least 6 characters");
      return;
    }
    if (!_agreed) {
      CustomToast.showErrorToast(msg: "Please agree to the terms and conditions");
      return;
    }

    final authController = Get.find<AuthController>();
    await authController.register(
      childNickname: nickname,
      childAge: age,
      childGrade: _selectedGrade,
      isNeurodivergent: _isNeurodivergent,
      parentEmail: email,
      password: password,
      termsAccepted: _agreed,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;
    final screenWidth = mediaQuery.size.width;

    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      showBackButton: true,
      onBack: () => Navigator.pop(context),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            width: isTablet
                ? (screenWidth * 0.52).clamp(420.0, 520.0)
                : (screenWidth * 0.65).clamp(340.0, 480.0),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEEFBD5), // Soft pastel lime
                  Color(0xFFD6F9C7), // Light fresh green
                  Color(0xFFC0F4DA), // Soft pastel mint
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Title
                Text(
                  "Let's set up a child profile",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 18),

                // Child's Nickname
                _buildNestedInputField(
                  label: "Child's Nickname",
                  hint: "Enter nickname",
                  controller: _nicknameController,
                ),
                const SizedBox(height: 12),

                // Child Age
                _buildNestedInputField(
                  label: "Child Age",
                  hint: "Enter child age",
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Parent Email
                _buildNestedInputField(
                  label: "Parent Email",
                  hint: "Enter parent email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                // Password
                _buildNestedInputField(
                  label: "Password",
                  hint: "Enter password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF475569),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Terms & Conditions Checkbox Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreed,
                        activeColor: const Color(0xFF0F2537),
                        checkColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF475569),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        onChanged: (val) async {
                          if (val == true) {
                            final agreed = await TermsAgreementDialog.show(context);
                            if (agreed == true) {
                              setState(() => _agreed = true);
                            }
                          } else {
                            setState(() => _agreed = false);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (!_agreed) {
                            final agreed = await TermsAgreementDialog.show(context);
                            if (agreed == true) {
                              setState(() => _agreed = true);
                            }
                          } else {
                            setState(() => _agreed = false);
                          }
                        },
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.nunito(
                              color: const Color(0xFF0F172A),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              const TextSpan(text: 'Check here to agree to '),
                              TextSpan(
                                text: 'terms and conditions',
                                style: GoogleFonts.nunito(
                                  decoration: TextDecoration.underline,
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w900,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    AppWebViewScreen.open(
                                      context,
                                      url: AppConstants.TERMS_URL,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sign up with email CTA Button
                Obx(() {
                  final authController = Get.find<AuthController>();
                  final isLoading = authController.isLoading.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F2537), // Dark navy CTA
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: isLoading ? null : _handleSignUp,
                      child: isLoading
                          ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                          : Text(
                              'Sign up with email',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Already have an account? Sign In
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF0F172A),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: GoogleFonts.nunito(
                            color: const Color(0xFF2563EB),
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => SignInDialog.show(context),
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

  Widget _buildNestedInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 14,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon,
            ],
          ),
        ],
      ),
    );
  }
}
