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
                child: Image.asset(
                  'assets/images/src_assets_icons_litto_star.png',
                  height: 70,
                  width: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.star_rounded,
                    size: 80,
                    color: Color(0xFFFFD54F),
                  ),
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
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/src_assets_icons_explore_challenge.png',
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    // START Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/src_assets_icons_challange_start.png',
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                    ),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/src_assets_icons_skip_challenge.png',
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
