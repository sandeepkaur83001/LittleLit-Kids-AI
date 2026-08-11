import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String gameTitle;
  const CategorySelectionScreen({super.key, required this.gameTitle});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Transportation', 'image': 'https://picsum.photos/400/400?random=11'},
    {'title': 'Forests & Animals', 'image': 'https://picsum.photos/400/400?random=12'},
    {'title': 'Human Body', 'image': 'https://picsum.photos/400/400?random=13'},
    {'title': 'Earth and World', 'image': 'https://picsum.photos/400/400?random=14'},
    {'title': 'Ask Your Question', 'isSpecial': true},
    {'title': 'Women Heroes', 'image': 'https://picsum.photos/400/400?random=15'},
    {'title': 'Science', 'image': 'https://picsum.photos/400/400?random=16'},
  ];

  final PageController _pageController = PageController(
    initialPage: 2,
    viewportFraction: 0.22,
  );
  double _currentPage = 2.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = _pageController.page ?? 2.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 10),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: categories.length,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    double diff = (index - _currentPage);
                    double value = (1 - (diff.abs() * 0.4)).clamp(0.0, 1.0);
                    double scale = 0.8 + (value * 0.2);

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: _buildCategoryCard(categories[index], value > 0.8),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
          // Dragon character in bottom right
          Positioned(
            bottom: 10,
            right: 20,
            child: Image.asset(
              'assets/images/magic_image.png',
              height: 120,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Character
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All About me!',
                      style: GoogleFonts.comicNeue(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/magic_image.png',
                      height: 45,
                      width: 45,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:10),
              child: Text(
                'What kind of question should we learn about today?',
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
          ),

          // Close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF80CBC4).withOpacity(0.6), // Light teal
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.black54, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, bool isSelected) {
    if (category['isSpecial'] == true) {
      return _buildSpecialCard(category, isSelected);
    }

    return Container(
      width: 200,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.2 : 0.08),
            blurRadius: isSelected ? 15 : 8,
            offset: Offset(0, isSelected ? 8 : 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                category['image'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['title'],
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildSpecialCard(Map<String, dynamic> category, bool isSelected) {
    return Container(
      width: 220,
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF4DB6AC), // Teal color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.2 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Speech bubble tail effect (simplified)
          Positioned(
            bottom: -10,
            left: 100,
            child: Transform.rotate(
              angle: 0.8,
              child: Container(
                width: 20,
                height: 20,
                color: const Color(0xFF4DB6AC),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Type or Talk...',
                  style: GoogleFonts.comicNeue(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD54F), // Yellow
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Color(0xFF4DB6AC)),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Text(
                category['title'],
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF444444),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
