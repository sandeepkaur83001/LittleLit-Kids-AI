import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/coloring_art_screen.dart';

class MagicArtScreen extends StatefulWidget {
  const MagicArtScreen({super.key});

  @override
  State<MagicArtScreen> createState() => _MagicArtScreenState();
}

class _MagicArtScreenState extends State<MagicArtScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  bool _hasResult = false;
  String _generatedImage = 'assets/images/magic_image.png';

  late AnimationController _wandAnimController;

  final List<Map<String, String>> _ideas = [
    {'text': 'A supergirl with wings', 'image': 'assets/images/coloring_arts.png'},
    {'text': 'A bunny with a hat and shoes', 'image': 'assets/images/chameleon.png'},
    {'text': 'A singer duck rockstar', 'image': 'assets/images/duck_singer.png'},
    {'text': 'A cute baby dragon with fire', 'image': 'assets/images/litto.png'},
  ];

  @override
  void initState() {
    super.initState();
    _wandAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _wandAnimController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  void _generateArt({String? prompt, String? fallbackImage}) {
    final text = prompt ?? _promptController.text.trim();
    if (text.isEmpty && prompt == null) return;

    setState(() {
      _isGenerating = true;
      _hasResult = false;
    });

    // Simulate instant magical generation
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _hasResult = true;
          _generatedImage = fallbackImage ?? _ideas[DateTime.now().second % _ideas.length]['image']!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.88,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Close Button
              Positioned(
                top: 15,
                right: 15,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/images/src_assets_icons_btn_cross.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF80CBC4).withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.black54, size: 26),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(36, 16, 36, 16),
                child: _isGenerating
                    ? _buildGeneratingView()
                    : _hasResult
                        ? _buildResultView()
                        : _buildInputView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Magic Art',
            style: GoogleFonts.comicNeue(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Just tell me what you are imagining and I will make a fun picture for you.',
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(
              fontSize: 16,
              color: const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 16),

          // Input Card Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF81C784).withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    style: GoogleFonts.comicNeue(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type or describe here...',
                      hintStyle: GoogleFonts.comicNeue(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (val) => _generateArt(prompt: val),
                  ),
                ),

                // Mic Button
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/src_assets_icons_btn_mic.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD54F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mic, color: Colors.white, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Generate / Send Button
                GestureDetector(
                  onTap: () => _generateArt(),
                  child: Image.asset(
                    'assets/images/src_assets_icons_btn_next.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E78C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 26),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Idea Chips Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/src_assets_icons_magic_idea.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFFFB300), size: 28),
                  ),
                  Text(
                    'Ideas',
                    style: GoogleFonts.comicNeue(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00897B),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: _ideas.map((idea) {
                    return GestureDetector(
                      onTap: () {
                        _promptController.text = idea['text']!;
                        _generateArt(prompt: idea['text']!, fallbackImage: idea['image']);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB2EBF2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF80DEEA), width: 1.2),
                        ),
                        child: Text(
                          idea['text']!,
                          style: GoogleFonts.comicNeue(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF006064),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _wandAnimController,
            builder: (context, child) {
              final scale = 0.9 + (_wandAnimController.value * 0.25);
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFFFDE7), Color(0xFFFFEE58), Color(0xFFFFD54F)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD54F).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/magic_image.png',
                    height: 80,
                    width: 80,
                    errorBuilder: (_, __, ___) => const Icon(Icons.auto_fix_high_rounded, size: 60, color: Colors.blue),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Casting Magic Spell...',
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Creating your customized masterpiece art!',
            style: GoogleFonts.comicNeue(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Row(
      children: [
        // Left Preview Card
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF60A5FA), width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                _generatedImage,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Right Actions
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '✨ Magic Created!',
                style: GoogleFonts.comicNeue(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _promptController.text.isNotEmpty ? '"${_promptController.text}"' : 'Your imagined art',
                style: GoogleFonts.comicNeue(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // Color this art button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E78C7),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ColoringArtScreen()),
                  );
                },
                icon: const Icon(Icons.brush_rounded, color: Colors.white),
                label: Text(
                  'Color This Art',
                  style: GoogleFonts.comicNeue(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              // Try another prompt
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Color(0xFF2E78C7), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    _hasResult = false;
                    _promptController.clear();
                  });
                },
                icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2E78C7)),
                label: Text(
                  'Try Another Idea',
                  style: GoogleFonts.comicNeue(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2E78C7)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
