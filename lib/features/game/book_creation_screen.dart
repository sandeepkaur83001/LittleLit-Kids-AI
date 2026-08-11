import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class BookCreationScreen extends StatelessWidget {
  const BookCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.green.shade200.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 50,
                child: Column(
                  children: [
                    const Icon(Icons.menu_book, size: 60, color: Colors.green),
                    const SizedBox(height: 5),
                    const Icon(Icons.sentiment_very_satisfied, color: Colors.green),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(120, 20, 60, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'First, lets build an idea for your book. What kind of story world do you want to create?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 220,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildThemeCard('Fantasy', 'https://picsum.photos/150/200?random=11'),
                            const SizedBox(width: 15),
                            _buildThemeCard('Mystery', 'https://picsum.photos/150/200?random=12'),
                            const SizedBox(width: 15),
                            _buildThemeCard('Diary', 'https://picsum.photos/150/200?random=13'),
                            const SizedBox(width: 15),
                            _buildThemeCard('Theme', 'https://picsum.photos/150/200?random=14'),
                          ],
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
    );
  }

  Widget _buildThemeCard(String title, String imageUrl) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF2C7A9F),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              style: GoogleFonts.comicNeue(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
