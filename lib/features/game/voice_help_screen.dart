import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class VoiceHelpScreen extends StatefulWidget {
  const VoiceHelpScreen({super.key});

  @override
  State<VoiceHelpScreen> createState() => _VoiceHelpScreenState();
}

class _VoiceHelpScreenState extends State<VoiceHelpScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _textController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.90, end: 1.12).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onActionTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SubscriptionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GameBackground(
        backgroundImage: 'assets/images/src_assets_background_home_main.png',
        child: SafeArea(
          child: Center(
            child: Container(
              width: size.width * 0.90,
              height: size.height * 0.86,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.82),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Top Right Close Button
                  Positioned(
                    top: 18,
                    right: 18,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/src_assets_icons_btn_cross.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF99D8E6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF334155),
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Prompt Text & Input Area
                  Positioned(
                    top: size.height * 0.16,
                    left: 48,
                    right: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _textController,
                          cursorColor: const Color(0xFF475569),
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                          onSubmitted: (_) => _onActionTap(),
                          decoration: InputDecoration(
                            hintText: 'Need help using LittleLit? Just Ask or Type...',
                            hintStyle: GoogleFonts.nunito(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Side Yellow Mic Button
                  Positioned(
                    right: 32,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _onActionTap,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Image.asset(
                                'assets/images/src_assets_icons_music_mic.png',
                                width: 92,
                                height: 92,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/src_assets_icons_btn_mic.png',
                                  width: 92,
                                  height: 92,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Bottom Center Next/Submit Arrow Button
                  Positioned(
                    bottom: 22,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _onActionTap,
                        child: Image.asset(
                          'assets/images/src_assets_icons_btn_next.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF99D8E6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF334155),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
