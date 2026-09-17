import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/auth/controllers/auth_controller.dart';
import 'package:little_kids_ai/features/auth/widgets/sign_in_dialog.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String? initialEmail;

  const ResetPasswordDialog({super.key, this.initialEmail});

  static void show(BuildContext context, {String? initialEmail}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordDialog(initialEmail: initialEmail),
      ),
    );
  }

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final code = _codeController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final email = widget.initialEmail?.trim() ?? Globals.currentUser?.email ?? '';

    if (code.isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter the code sent to your email");
      return;
    }
    if (password.isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter new password");
      return;
    }
    if (password.length < 6) {
      CustomToast.showErrorToast(msg: "Password must be at least 6 characters");
      return;
    }
    if (confirmPassword.isEmpty) {
      CustomToast.showErrorToast(msg: "Please confirm your new password");
      return;
    }
    if (password != confirmPassword) {
      CustomToast.showErrorToast(msg: "Passwords do not match");
      return;
    }

    final authController = Get.find<AuthController>();
    final success = await authController.resetPassword(
      token: code,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInDialog(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isTablet = mediaQuery.size.shortestSide >= 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF26B5E8), // Vivid cyan blue
              Color(0xFF48CFCD), // Teal cyan
              Color(0xFF90DC8C), // Soft lime green
              Color(0xFFF5E05B), // Soft yellow
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Top Bar with Back Button and Reset Password Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A80E2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      "Reset Password",
                      style: GoogleFonts.nunito(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),

              // Centered Content Form
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet
                          ? (screenWidth * 0.52).clamp(420.0, 520.0)
                          : (screenWidth * 0.65).clamp(340.0, 480.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),

                        // Enter Code Field
                        _buildInputField(
                          label: "Enter Code",
                          hint: "Enter code",
                          controller: _codeController,
                        ),
                        const SizedBox(height: 14),

                        // New Password Field
                        _buildInputField(
                          label: "New Password",
                          hint: "Enter new password",
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF0F172A),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Confirm Password Field
                        _buildInputField(
                          label: "Confirm Password",
                          hint: "Enter confirm password",
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF0F172A),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Submit Button
                        Obx(() {
                          final authController = Get.find<AuthController>();
                          final isLoading = authController.isLoading.value;
                          return SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F2537), // Dark navy button
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: isLoading ? null : _onSubmit,
                              child: isLoading
                                  ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                                  : Text(
                                      "Submit",
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
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
              ),
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
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 15,
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
