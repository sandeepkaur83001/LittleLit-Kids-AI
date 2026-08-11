import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final List<Map<String, dynamic>> categories = [
    {'label': 'Book', 'color': const Color(0xFFFFB7B7)},
    {'label': 'Music', 'color': const Color(0xFFFFE897)},
    {'label': 'Magic Art', 'color': const Color(0xFFF0FAD1)},
    {'label': 'Ask Litto', 'color': const Color(0xFFC5E1A5)},
    {'label': 'STEM Projects', 'color': const Color(0xFFB2EBF2)},
    {'label': 'Puzzles', 'color': const Color(0xFF80CBC4)},
    {'label': 'Designs', 'color': const Color(0xFFF5F5F5)},
    {'label': 'Art', 'color': const Color(0xFFFFE082)},
  ];

  int _selectedCat = 0;

  void _onCategorySelected(int index) {
    setState(() => _selectedCat = index);
    // ApiService.fetchPortfolio(categories[index]['label']); // API Call: Filter portfolio items
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildHeader(context),
                    const Spacer(),
                    _buildTopRow(),
                    const SizedBox(height: 15),
                    _buildCategoryBar(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF80CBC4).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.black54, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          // Weekly Contest Banner
          Expanded(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'ENTER WEEKLY CONTEST TO WIN PRIZES',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF444444),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB2EBF2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black54, size: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // My Portfolio Card
          Container(
            width: 200,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/magic_image.png',
                      height: 30,
                    ),
                    Text(
                      'My portfolio',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00ACC1),
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFFFB74D),
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Column(
      children: [
        // Top star line
        _buildStarLine(),
        Container(
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFB2EBF2).withOpacity(0.5),
            borderRadius: BorderRadius.circular(55),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              bool isSelected = index == _selectedCat;
              return GestureDetector(
                onTap: () => _onCategorySelected(index),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: categories[index]['color'],
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      categories[index]['label'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Bottom star line
        _buildStarLine(),
      ],
    );
  }

  Widget _buildStarLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFF00ACC1), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: const [
                Icon(Icons.star_outline, size: 16, color: Color(0xFF00ACC1)),
                Icon(Icons.star, size: 20, color: Color(0xFF00ACC1)),
                Icon(Icons.star_outline, size: 16, color: Color(0xFF00ACC1)),
              ],
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFF00ACC1), thickness: 1)),
        ],
      ),
    );
  }
}
