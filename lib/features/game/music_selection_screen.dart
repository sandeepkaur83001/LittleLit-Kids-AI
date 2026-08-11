import 'package:little_kids_ai/core/common_imports.dart';

class MusicSelectionBottomSheet extends StatelessWidget {
  const MusicSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'label': 'EXCITED', 'image': 'assets/images/excited.png', 'isAngled': true},
      {'label': 'HAPPY', 'image': 'assets/images/happy.png', 'isAngled': false},
      {'label': 'SILLY', 'image': 'assets/images/silly.png', 'isAngled': false},
      {'label': 'TIRED', 'image': 'assets/images/tired.png', 'isAngled': false},
      {'label': 'SAD', 'image': 'assets/images/sad.png', 'isAngled': false},
      {'label': 'ANXIOUS', 'image': 'assets/images/anxious.png', 'isAngled': true},
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        image: DecorationImage(
          image: AssetImage('assets/images/background_clean.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Background Bubbles Placeholder (Simplified)
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: BubblePainter(),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Top Handle
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 25),
              // Groovy time text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Groovy time! Pick how do you feel and let's play some music that'll make you smile",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Mood Items Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: moods.map((mood) => _buildMoodItem(mood)).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodItem(Map<String, dynamic> mood) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          Transform.rotate(
            angle: mood['isAngled'] ? -0.15 : 0.0,
            child: Text(
              mood['label'],
              style: GoogleFonts.comicNeue(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Mood Image (Character + Note)
          Image.asset(
            mood['image'],
            height: 160,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 160,
              width: 80,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ],
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.5), 20, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 35, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.7), 15, paint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 25, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
