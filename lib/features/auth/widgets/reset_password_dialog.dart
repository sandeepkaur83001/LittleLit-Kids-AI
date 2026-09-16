import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/auth/controllers/auth_controller.dart';
import 'package:little_kids_ai/features/auth/widgets/sign_in_dialog.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String? initialEmail;

  const ResetPasswordDialog({super.key, this.initialEmail});

  static void show(BuildContext context, {String? initialEmail}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ResetPasswordDialog(initialEmail: initialEmail),
    );
  }

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  late TextEditingController _emailController;
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onReset() async {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter your email");
      return;
    }
    if (token.isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter the reset token received in email");
      return;
    }
    if (password.length < 6) {
      CustomToast.showErrorToast(msg: "Password must be at least 6 characters");
      return;
    }
    if (password != confirmPassword) {
      CustomToast.showErrorToast(msg: "Passwords do not match");
      return;
    }

    final authController = Get.find<AuthController>();
    final success = await authController.resetPassword(
      token: token,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    if (success && mounted) {
      Navigator.pop(context);
      SignInDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = mediaQuery.size.shortestSide >= 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        width: isTablet
            ? (screenWidth * 0.55).clamp(380.0, 520.0)
            : (screenWidth * 0.85).clamp(280.0, 420.0),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F58E),
              Color(0xFF8FE6E1),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reset Password",
                    style: GoogleFonts.comicNeue(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: "Email",
                hint: "Registered email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                label: "Reset Token",
                hint: "Enter token from email",
                controller: _tokenController,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                label: "New Password",
                hint: "Minimum 6 characters",
                controller: _passwordController,
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                label: "Confirm New Password",
                hint: "Confirm new password",
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
              ),
              const SizedBox(height: 20),

              Obx(() {
                final authController = Get.find<AuthController>();
                final isLoading = authController.isLoading.value;
                return SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E78C7),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading ? null : _onReset,
                    child: isLoading
                        ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                        : Text(
                            "Reset Password",
                            style: GoogleFonts.comicNeue(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            label,
            style: GoogleFonts.comicNeue(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF555555),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: GoogleFonts.comicNeue(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.comicNeue(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
