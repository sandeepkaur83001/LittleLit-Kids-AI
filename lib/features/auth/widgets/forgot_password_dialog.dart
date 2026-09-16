import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/auth/controllers/auth_controller.dart';
import 'package:little_kids_ai/features/auth/widgets/reset_password_dialog.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ForgotPasswordDialog(),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter your registered email");
      return;
    }

    final authController = Get.find<AuthController>();
    final success = await authController.forgotPassword(email: email);
    if (success && mounted) {
      Navigator.pop(context);
      ResetPasswordDialog.show(context, initialEmail: email);
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
                    "Forgot Password",
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
              const SizedBox(height: 12),
              Text(
                "Enter your parent email address and we will send you instructions to reset your password.",
                style: GoogleFonts.comicNeue(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 20),

              // Email Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      "Parent Email",
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.comicNeue(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.email_outlined, color: Colors.blue.shade400, size: 20),
                        hintText: "Enter email address",
                        hintStyle: GoogleFonts.comicNeue(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit Button
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
                    onPressed: isLoading ? null : _onSubmit,
                    child: isLoading
                        ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                        : Text(
                            "Send Reset Code",
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
}
