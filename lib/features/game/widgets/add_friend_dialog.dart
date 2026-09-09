import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFriendDialog extends StatefulWidget {
  final String mySecretKey;

  const AddFriendDialog({
    super.key,
    this.mySecretKey = 'Test473',
  });

  static void show(BuildContext context, {String mySecretKey = 'Test473'}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AddFriendDialog(mySecretKey: mySecretKey),
    );
  }

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final TextEditingController _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _submitKey() {
    final text = _keyController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your friend\'s secret key'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend with key "$text" added successfully!'),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareSecretKey() {
    Clipboard.setData(ClipboardData(text: widget.mySecretKey));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Secret key "${widget.mySecretKey}" copied to clipboard!'),
        backgroundColor: const Color(0xFF0284C7),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;
    final screenWidth = mediaQuery.size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: isTablet
                ? math.min(screenWidth * 0.65, 500.0)
                : math.min(screenWidth * 0.92, 440.0),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFAED581), // Soft pastel green
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Add your friend',
                      style: GoogleFonts.comicNeue(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Input Box
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8E9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _keyController,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        style: GoogleFonts.comicNeue(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter their secret key',
                          hintStyle: GoogleFonts.comicNeue(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF558B2F),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onSubmitted: (_) => _submitKey(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Circular Check Button
                    GestureDetector(
                      onTap: _submitKey,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8E6C9).withOpacity(0.75),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Color(0xFF2E7D32),
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Bottom Row: Magic Key + Yellow Secret Key Box (closely attached)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Magic Star Key Graphic pointing right directly next to card
                        Image.asset(
                          'assets/images/src_assets_icons_friend_key.png',
                          height: 48,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.vpn_key_rounded,
                            size: 36,
                            color: Color(0xFFFFD54F),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Right Yellow Box
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD54F),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tell them your secret key',
                                  style: GoogleFonts.comicNeue(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF3E2723),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Secret Key Display Box
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.mySecretKey,
                                    style: GoogleFonts.comicNeue(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Share Button
                                GestureDetector(
                                  onTap: _shareSecretKey,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF29B6F6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.reply_rounded,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Share',
                                          style: GoogleFonts.comicNeue(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
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
                      ],
                    ),
                  ],
                ),

                // Top-Right Close Button
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB2DFDB).withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF1E293B),
                        size: 20,
                      ),
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
}
