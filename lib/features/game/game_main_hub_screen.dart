import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/portfolio_screen.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/controllers/interests_controller.dart';

class GameMainHubScreen extends StatefulWidget {
  const GameMainHubScreen({super.key});

  @override
  State<GameMainHubScreen> createState() => _GameMainHubScreenState();
}

class _GameMainHubScreenState extends State<GameMainHubScreen> {
  final InterestsController _interestsController = Get.find<InterestsController>();

  @override
  void initState() {
    super.initState();
    _interestsController.fetchInterests();
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      child: Column(
        children: [
          _buildTopBar(),
          const Spacer(),
          _buildContestBanner(),
          const SizedBox(height: 20),
          _buildBottomNavBar(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/images/src_assets_icons_btn_cross.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContestBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ENTER WEEKLY CONTEST TO WIN PRIZES',
                      style: GoogleFonts.comicNeue(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/src_assets_images_blue_next.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.cyan.shade100, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PortfolioScreen()),
              );
            },
            child: Container(
              width: 190,
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/src_assets_icons_my_portpolio.png',
                      height: 58,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.palette, size: 40, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/src_assets_icons_port_my_next.png',
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.arrow_forward_rounded, color: Colors.orange, size: 32),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.cyan.shade100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Obx(() {
        final interests = _interestsController.interestList;
        final selected = _interestsController.selectedInterest.value;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: interests.length,
          itemBuilder: (context, index) {
            final item = interests[index];
            final bool isSelected = (selected != null && selected.id == item.id) || (item.isSelected == true);
            final color = _interestsController.getColorForIndex(index);

            return GestureDetector(
              onTap: () => _interestsController.selectInterest(item),
              child: Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  item.name ?? '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
