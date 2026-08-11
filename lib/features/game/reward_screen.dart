import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      child: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: _buildMainContent(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          _buildTabButton('Sticker', const Color(0xFFFFB7B7), 0),
          const SizedBox(width: 15),
          _buildTabButton('Badge', const Color(0xFFFFE897), 1),
          const SizedBox(width: 15),
          _buildTabButton('Weekly\nWinner', const Color(0xFFC5E1A5), 2),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.black54, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, Color color, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.comicNeue(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://img.freepik.com/free-vector/hand-drawn-notebook-paper-background_23-2149488346.jpg'), // Placeholder for notebook pattern
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Text(
            'As soon as you create something it will show up here!',
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF444444),
            ),
          ),
        ),
      ),
    );
  }
}
