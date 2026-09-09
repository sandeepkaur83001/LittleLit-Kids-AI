import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/subscription_screen.dart';

class MagicArtScreen extends StatefulWidget {
  const MagicArtScreen({super.key});

  @override
  State<MagicArtScreen> createState() => _MagicArtScreenState();
}

class _MagicArtScreenState extends State<MagicArtScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  final List<String> _ideas = [
    'A supergirl with wings',
    'A bunny with a hat and shoes',
    'A race car with fire stripes',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  void _openSubscription() {
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
              width: size.width * 0.94,
              height: size.height * 0.92,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),
                borderRadius: BorderRadius.circular(24),
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
                    top: 12,
                    right: 14,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/src_assets_icons_btn_cross.png',
                        width: 38,
                        height: 38,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFF99D8E6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF334155),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title & Subtitle Header
                        Text(
                          'Magic Art',
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Just tell me what you are imagining and I will make a fun picture for you.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Big Mint Green Box with centered text input and yellow mic on right
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF97DCB0),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Center TextField
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50),
                                  child: TextField(
                                    controller: _promptController,
                                    textAlign: TextAlign.center,
                                    cursorColor: const Color(0xFF334155),
                                    textInputAction: TextInputAction.none,
                                    keyboardType: TextInputType.text,
                                    style: GoogleFonts.nunito(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF334155),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Type or Talk...',
                                      hintStyle: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF4A7C59).withOpacity(0.7),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),

                                // Right-aligned Yellow Mic Button
                                Positioned(
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: _openSubscription,
                                    child: AnimatedBuilder(
                                      animation: _scaleAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _scaleAnimation.value,
                                          child: Image.asset(
                                            'assets/images/src_assets_icons_music_mic.png',
                                            width: 78,
                                            height: 78,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => Image.asset(
                                              'assets/images/src_assets_icons_btn_mic.png',
                                              width: 78,
                                              height: 78,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Next Arrow Button row (separate row aligned to right, under mic)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: GestureDetector(
                              onTap: _openSubscription,
                              child: Image.asset(
                                'assets/images/src_assets_icons_btn_next.png',
                                width: 38,
                                height: 38,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF97DCB0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF1E293B),
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Bottom Ideas Row: ideas bulb icon on left + horizontal scroll of chips
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ideas icon & text
                            Image.asset(
                              'assets/images/src_assets_icons_magic_idea.png',
                              height: 36,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lightbulb_outline_rounded,
                                      color: Color(0xFFEAB308), size: 18),
                                  Text(
                                    'ideas',
                                    style: GoogleFonts.comicNeue(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF15803D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Idea Chips
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: _ideas.map((idea) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: GestureDetector(
                                        onTap: _openSubscription,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBAE6FD),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFF7DD3FC),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            idea,
                                            style: GoogleFonts.nunito(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                      ],
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
