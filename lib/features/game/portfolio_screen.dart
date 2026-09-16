import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/game_main_hub_screen.dart';
import 'package:little_kids_ai/features/game/game_screen.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/child_canvas_portfolio_screen.dart';
import 'package:little_kids_ai/features/game/widgets/add_friend_dialog.dart';
import 'package:little_kids_ai/features/profile/controllers/profile_controller.dart';

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
      child: SafeArea(
        child: Column(
          children: [
            // Dedicated Top Close Button Bar
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 18, bottom: 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/images/src_assets_icons_btn_cross.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF80CBC4).withOpacity(0.75),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close, color: Colors.black87, size: 24),
                    ),
                  ),
                ),
              ),
            ),

            // Main Content List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 2, bottom: 24),
                children: [
                  // Top Row (Contest & Portfolio card)
                  _buildTopRow(),
                  const SizedBox(height: 10),

                  // Categories Bar with Star Dividers
                  _buildCategoryBar(),
                  const SizedBox(height: 12),

                  // Child Header Row
                  _buildUserCreationsSection(),
                  const SizedBox(height: 8),

                  // Child Creations Horizontal Cards
                  _buildCreationsHorizontalList(),
                  const SizedBox(height: 16),

                  // Friends Header Row
                  _buildFriendsSection(),
                  const SizedBox(height: 8),

                  // Friends Creations Horizontal Cards
                  _buildFriendsHorizontalList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Weekly Contest Banner
          Expanded(
            child: Container(
              height: 84,
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                children: [
                  Expanded(
                    child: Text(
                      'ENTER WEEKLY CONTEST TO WIN PRIZES',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // fontStyle: FontStyle.italic,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      RouteNavigate().navigateToPush(context, GameScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB2EBF2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.black87, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          // My Portfolio Card
          GestureDetector(
            onTap: () {
              final childName = Get.find<ProfileController>().userProfile.value?.childNickname ??
                  Globals.currentUser?.childNickname;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChildCanvasPortfolioScreen(childName: childName),
                ),
              );
            },
            child: Container(
              height: 84,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
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
              child:  Image.asset(
                'assets/images/src_assets_icons_port_my_next.png',
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFFFFB74D),
                  size: 34,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Column(
      children: [
        _buildStarLine(),
        Container(
          height: 95,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFB2EBF2).withOpacity(0.45),
            borderRadius: BorderRadius.circular(48),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              bool isSelected = index == _selectedCat;
              return GestureDetector(
                onTap: () => _onCategorySelected(index),
                child: Container(
                  width: 82,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: categories[index]['color'],
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Colors.black, width: 3.0) : null,
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      categories[index]['label'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 13,
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
        _buildStarLine(),
      ],
    );
  }

  Widget _buildUserCreationsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(() {
            final childName = Get.find<ProfileController>().userProfile.value?.childNickname ??
                Globals.currentUser?.childNickname ??
                'My Creations';
            return Text(
              childName,
              style: GoogleFonts.comicNeue(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            );
          }),
          const Spacer(),
          // Share with friends button
          GestureDetector(
            onTap: () => AddFriendDialog.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    'Share with friends',
                    style: GoogleFonts.comicNeue(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/images/src_assets_icons_share_icon.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF43F5E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'View All',
            style: GoogleFonts.comicNeue(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreationsHorizontalList() {
    final List<Map<String, String>> sampleCreations = [
      {'title': 'Space Rocket', 'image': 'assets/images/coloring_arts.png'},
      {'title': 'Magic Forest', 'image': 'assets/images/chameleon.png'},
      {'title': 'Happy Castle', 'image': 'assets/images/duck_singer.png'},
      {'title': 'Dragon Tale', 'image': 'assets/images/litto.png'},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: sampleCreations.length,
        itemBuilder: (context, index) {
          final item = sampleCreations[index];
          return Container(
            width: 130,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Text(
                    item['title']!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.comicNeue(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFriendsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'My Friends',
            style: GoogleFonts.comicNeue(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => AddFriendDialog.show(context),
            child: Image.asset(
              'assets/images/src_assets_icons_add_friend.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                ),
                child: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0284C7), size: 18),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'View All',
            style: GoogleFonts.comicNeue(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsHorizontalList() {
    final List<Map<String, String>> friendsCreations = [
      {'title': "Lily's Drawing", 'image': 'assets/images/chameleon.png'},
      {'title': "Leo's Robot", 'image': 'assets/images/build_projects.png'},
      {'title': "Mia's Song", 'image': 'assets/images/duck_singer.png'},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: friendsCreations.length,
        itemBuilder: (context, index) {
          final item = friendsCreations[index];
          return Container(
            width: 130,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Text(
                    item['title']!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.comicNeue(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStarLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFF00ACC1), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: const [
                Icon(Icons.star_outline, size: 14, color: Color(0xFF00ACC1)),
                Icon(Icons.star, size: 18, color: Color(0xFF00ACC1)),
                Icon(Icons.star_outline, size: 14, color: Color(0xFF00ACC1)),
              ],
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFF00ACC1), thickness: 1)),
        ],
      ),
    );
  }
}
