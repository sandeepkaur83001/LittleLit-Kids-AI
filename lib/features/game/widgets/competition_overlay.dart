import 'package:little_kids_ai/core/common_imports.dart';

class CompetitionOverlay extends StatelessWidget {
  const CompetitionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color : Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFF81D4FA).withOpacity(0.5), // Light blue background
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Title
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Text(
                  'Here is your weekly competition',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),

              // White Content Box
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Design a cool backpack showcasing your favorite animals',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
              ),

              // Chameleon Character
              Positioned(
                top: -30,
                right: -20,
                child: Image.asset(
                  'assets/images/chameleon.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),

              // Star Icon on left
              Positioned(
                left: -20,
                top: MediaQuery.of(context).size.height * 0.4,
                child: const Icon(
                  Icons.star_rounded,
                  size: 80,
                  color: Color(0xFFFFD54F),
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
                  ],
                ),
              ),

              // Bottom Buttons Row
              Positioned(
                bottom: 20,
                left: 40,
                right: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildIconButton('JUS\nEXPLORE', Icons.home_filled, const Color(0xFF81C784)),
                    
                    // START Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD54F), // Yellow
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.black),
                            Text(
                              'START',
                              style: GoogleFonts.comicNeue(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    _buildIconButton('SKIP TO\nNEXT', Icons.skip_next_rounded, const Color(0xFF81C784)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(String text, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
