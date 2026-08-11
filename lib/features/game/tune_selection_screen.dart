import 'package:little_kids_ai/core/common_imports.dart';

class TuneSelectionScreen extends StatelessWidget {
  const TuneSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tunes = [
      {'title': 'Twinkle Twinkle', 'id': '1'},
      {'title': 'Baby Shark', 'id': '2'},
      {'title': 'Mary Had a Little Lamb', 'id': '3'},
      {'title': 'ABC Song', 'id': '4'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC), // Light blue background
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Select a tune to begin',
                  style: GoogleFonts.comicNeue(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    // Duck Character
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Image.asset(
                        'assets/images/duck_image.png',
                        height: MediaQuery.of(context).size.height * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    // Tunes List
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 280,
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: const EdgeInsets.only(right: 20),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tunes.length,
                          itemBuilder: (context, index) {
                            return _buildTuneCard(tunes[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Close button
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F), // Yellow
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: const Icon(Icons.close, color: Colors.black54, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTuneCard(Map<String, String> tune) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer decorative circle
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
          // Main Black Circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFB3E5FC), width: 8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    tune['title']!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.comicNeue(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SELECT',
                    style: GoogleFonts.comicNeue(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
