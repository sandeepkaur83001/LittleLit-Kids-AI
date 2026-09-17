import 'package:get/get.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/controllers/friends_controller.dart';
import 'package:little_kids_ai/features/game/widgets/add_friend_dialog.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class AllFriendsScreen extends StatefulWidget {
  final int initialTabIndex;
  const AllFriendsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AllFriendsScreen> createState() => _AllFriendsScreenState();
}

class _AllFriendsScreenState extends State<AllFriendsScreen> with SingleTickerProviderStateMixin {
  final FriendsController _friendsController = Get.find<FriendsController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _friendsController.fetchFriends();
    _friendsController.fetchPendingRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/hills_background_clean.png',
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B), size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Header Title
                  Text(
                    'Friends & Invitations',
                    style: GoogleFonts.comicNeue(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                  // Add Friend Button
                  GestureDetector(
                    onTap: () => AddFriendDialog.show(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Add Friend',
                            style: GoogleFonts.comicNeue(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Obx(() {
                final pendingCount = _friendsController.pendingRequests.length;
                final friendsCount = _friendsController.friendsList.length;

                return TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: GoogleFonts.comicNeue(fontSize: 14, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: GoogleFonts.comicNeue(fontSize: 14, fontWeight: FontWeight.w600),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'My Friends ($friendsCount)'),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Invitations ($pendingCount)'),
                          if (pendingCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$pendingCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),

            // TabBar View Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFriendsTab(),
                  _buildRequestsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsTab() {
    return Obx(() {
      final friends = _friendsController.friendsList;

      if (_friendsController.isLoading.value && friends.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF0284C7)));
      }

      if (friends.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/duck_image.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.group_outlined,
                  size: 60,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'No friends added yet!',
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Share your secret key to connect with friends.',
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => AddFriendDialog.show(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Add Friend',
                    style: GoogleFonts.comicNeue(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => _friendsController.fetchFriends(),
        color: const Color(0xFF0284C7),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.95,
          ),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            final fallbackImages = [
              'assets/images/chameleon.png',
              'assets/images/build_projects.png',
              'assets/images/duck_singer.png',
              'assets/images/litto.png',
            ];
            final defaultImage = fallbackImages[index % fallbackImages.length];

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AppCardImage(
                        imageUrl: friend.profilePicture,
                        fallbackAsset: defaultImage,
                        fallbackIcon: Icons.person_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    friend.displayName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.comicNeue(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  if (friend.secretKey != null && friend.secretKey!.isNotEmpty)
                    Text(
                      '#${friend.secretKey}',
                      style: GoogleFonts.comicNeue(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0284C7),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildRequestsTab() {
    return Obx(() {
      final requests = _friendsController.pendingRequests;

      if (_friendsController.isLoading.value && requests.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF0284C7)));
      }

      if (requests.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 60,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(height: 12),
              Text(
                'No pending invitations',
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'When friends send you a request using your key, they will appear here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => _friendsController.fetchPendingRequests(),
        color: const Color(0xFF0284C7),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final userId = request.userId ?? request.id;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFACC15), width: 1.5),
                    ),
                    child: ClipOval(
                      child: AppCardImage(
                        imageUrl: request.profilePicture,
                        fallbackAsset: 'assets/images/litto.png',
                        fallbackIcon: Icons.person_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and Key
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.displayName,
                          style: GoogleFonts.comicNeue(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        if (request.secretKey != null && request.secretKey!.isNotEmpty)
                          Text(
                            'Secret Key: #${request.secretKey}',
                            style: GoogleFonts.comicNeue(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF854D0E),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Actions
                  Row(
                    children: [
                      // Accept
                      GestureDetector(
                        onTap: () {
                          if (userId != null) {
                            _friendsController.acceptRequest(userId);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                'Accept',
                                style: GoogleFonts.comicNeue(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Decline
                      GestureDetector(
                        onTap: () {
                          if (userId != null) {
                            _friendsController.rejectRequest(userId);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFFEF4444),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
