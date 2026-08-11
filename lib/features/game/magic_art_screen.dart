import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class MagicArtScreen extends StatelessWidget {
  const MagicArtScreen({super.key});

  void _onGenerateArt() {
    // final data = { "prompt": "User's imagined text", "userId": Globals.BearerToken };
    // ApiService.generateMagicArt(data); // API Call: Sending prompt to AI engine
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              // Close Button
              Positioned(
                top: 15,
                right: 15,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF80CBC4).withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.black54, size: 28),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Magic Art',
                        style: GoogleFonts.comicNeue(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Just tell me what you are imagining and I will make a fun picture for you.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                          fontSize: 16,
                          color: const Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Input Area
                      Stack(
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 140, // Reduced height from 180 to 140
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF81C784).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Type or Task here',
                              style: GoogleFonts.comicNeue(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          // Microphone Button
                          Positioned(
                            right: 25,
                            child: Container(
                              padding: const EdgeInsets.all(15), // Reduced padding from 20 to 15
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFD54F),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.mic, color: Colors.white, size: 40), // Reduced size from 50 to 40
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      // Arrow Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF80CBC4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward, color: Colors.black54),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Ideas Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lightbulb_outline, color: Color(0xFFFFD54F), size: 24),
                              Text(
                                'ideas',
                                style: GoogleFonts.comicNeue(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4DB6AC),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Flexible(child: _buildIdeaChip('A supergirl with wings')),
                          const SizedBox(width: 10),
                          Flexible(child: _buildIdeaChip('A bunny with a hat and shoes')),
                          const SizedBox(width: 10),
                          Flexible(child: _buildIdeaChip('A race car with fire stripes')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdeaChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB2EBF2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.comicNeue(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF444444),
        ),
      ),
    );
  }
}
