import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChangePassword() async {
    final currentPass = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (currentPass.isEmpty) {
      CustomToast.showErrorToast(msg: "Please enter current password");
      return;
    }
    if (newPass.length < 6) {
      CustomToast.showErrorToast(msg: "New password must be at least 6 characters");
      return;
    }
    if (newPass != confirmPass) {
      CustomToast.showErrorToast(msg: "New passwords do not match");
      return;
    }

    final profileController = Get.find<ProfileController>();
    final success = await profileController.changePassword(
      currentPassword: currentPass,
      password: newPass,
      passwordConfirmation: confirmPass,
    );

    if (success && mounted) {
      Navigator.pop(context);
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
                    "Change Password",
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
              const SizedBox(height: 18),

              _buildInputField(
                label: "Current Password",
                hint: "Enter current password",
                controller: _currentPasswordController,
                obscureText: _obscure,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                label: "New Password",
                hint: "Minimum 6 characters",
                controller: _newPasswordController,
                obscureText: _obscure,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                label: "Confirm New Password",
                hint: "Confirm new password",
                controller: _confirmPasswordController,
                obscureText: _obscure,
              ),
              const SizedBox(height: 20),

              GetX<ProfileController>(
                builder: (controller) {
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
                      onPressed: controller.isLoading.value ? null : _onChangePassword,
                      child: controller.isLoading.value
                          ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                          : Text(
                              "Update Password",
                              style: GoogleFonts.comicNeue(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
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
