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
      useSafeArea: false,
      child: Column(
        children: [
          _buildTopBar(context),
          const SizedBox(height: 16),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final leftPadding = MediaQuery.of(context).padding.left;
    final rightPadding = MediaQuery.of(context).padding.right;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFBEE7F8),
      ),
      padding: EdgeInsets.only(
        top: topPadding > 0 ? topPadding + 4 : 8,
        bottom: 8,
        left: leftPadding > 0 ? leftPadding + 16 : 20,
        right: rightPadding > 0 ? rightPadding + 16 : 20,
      ),
      child: Row(
        children: [
          _buildTabButton('Sticker', const Color(0xFFFFB7B7), 0),
          const SizedBox(width: 14),
          _buildTabButton('Badge', const Color(0xFFFFE897), 1),
          const SizedBox(width: 14),
          _buildTabButton('Weekly\nWinner', const Color(0xFFC5E1A5), 2),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/images/src_assets_icons_btn_cross.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.black54, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, Color color, int index) {
    final bool isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 3.5) : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.comicNeue(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/create_something_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          width: screenWidth * 0.60,
          height: screenHeight * 0.60,
          margin: const EdgeInsets.only(top: 40),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF8F7).withOpacity(0.95), // Soft pastel mint card
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            'As soon as you create something\nit will show up here!',
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}
