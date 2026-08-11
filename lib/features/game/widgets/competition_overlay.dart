import 'package:little_kids_ai/core/common_imports.dart';

class CompetitionOverlay extends StatelessWidget {
  const CompetitionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.blue.shade200.withOpacity(0.95),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Text(
                  'Here is your weekly competition',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.35,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Design a cool backpack showcasing your favorite animals',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                bottom: 40,
                child: _buildSmallButton('JUST\nEXPLORE', Icons.home),
              ),
              Positioned(
                right: 40,
                bottom: 40,
                child: _buildSmallButton('SKIP TO\nNEXT', Icons.skip_next),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.play_arrow, size: 40),
                          Text(
                            'START',
                            style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 100,
                right: 20,
                child: Icon(Icons.emoji_emotions, size: 80, color: Colors.purple.shade300), // Placeholder for character
              ),
              Positioned(
                bottom: 120,
                left: 20,
                child: const Icon(Icons.star, size: 60, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton(String text, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ],
    );
  }
}
