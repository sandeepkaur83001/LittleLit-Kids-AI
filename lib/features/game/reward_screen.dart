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
      backgroundImage: "assets/images/landscape_background_clean.png",
      child: Column(
        children: [
          _buildTopBar(context),
          const SizedBox(height: 20),
          
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
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.7)
      ),
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
              padding: const EdgeInsets.all(6),
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 5) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.comicNeue(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.0,
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
          image: AssetImage('assets/images/create_something_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(

          width: MediaQuery.of(context).size.width*0.75,
          height: MediaQuery.of(context).size.height*0.7,
          margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color:  Colors.white, // Soft teal/cyan
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              'As soon as you create something it will show up here!',
              textAlign: TextAlign.center,
              style: GoogleFonts.comicNeue(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
