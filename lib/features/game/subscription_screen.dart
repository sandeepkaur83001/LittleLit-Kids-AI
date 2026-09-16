import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';
import 'package:little_kids_ai/features/game/game_screen.dart';
import 'package:little_kids_ai/widgets/common/app_web_view_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 0; // 0: Monthly (INR 590), 1: Annually (INR 4400)

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: 'assets/images/src_assets_background_litto_back.png',
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.60,
          margin: const EdgeInsets.only(top: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            image: const DecorationImage(
              image: AssetImage('assets/images/src_assets_background_home_page.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 18,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Scrollable card content
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top drag handle
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF94A3B8).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Top Title
                    Text(
                      'All in one creative outlet',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Free Plan Pill / Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF38BDF8), width: 1.2),
                      ),
                      child: Text(
                        'Free Plan: Daily one game free',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Section Heading
                    Text(
                      'Subscription Plans',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Two Plan Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPlanCard(
                          index: 0,
                          title: 'Billed Monthly',
                          price: 'INR 590',
                          isSelected: _selectedPlanIndex == 0,
                        ),
                        const SizedBox(width: 14),
                        _buildPlanCard(
                          index: 1,
                          title: 'Billed Annually',
                          price: 'INR 4400',
                          discount: '60% OFF',
                          isSelected: _selectedPlanIndex == 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Feature Bullets
                    Text(
                      'Create unlimited creative projects',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Upto 3 kids per family included\nNo ads, No other upsells',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Start Button (CTA)
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Starting 7-Day Free Trial...',
                              style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: const Color(0xFF2563EB),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const GameScreen()),
                          (route) => false,
                        );
                      },
                      child: _buildStartButton(),
                    ),
                    const SizedBox(height: 8),

                    // Footer Cancel Subtext
                    Text(
                      'Cancel anytime by going to app store settings',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 11.5,
                        color: const Color(0xFF374151),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 3 Links: Restore Purchase, Terms of Service, Privacy Policy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Restoring previous purchases...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            'Restore Purchase',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () {
                            AppWebViewScreen.open(
                              context,
                              url: AppConstants.TERMS_URL,
                            );
                          },
                          child: Text(
                            'Terms of Service',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: () {
                            AppWebViewScreen.open(
                              context,
                              url: 'https://www.littlelit.ai/privacy-policy',
                            );
                          },
                          child: Text(
                            'Privacy Policy',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Legal Terms text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '(1) At the end of 7 day free trial, you will be on paid subscription plan. Your card will be charged the subscription fees (monthly or annual)',
                            style: GoogleFonts.nunito(
                              fontSize: 10,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '(2) During the 7 day free trial, you can cancel anytime and you will not be charged, and converted to our free plan.',
                            style: GoogleFonts.nunito(
                              fontSize: 10,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              AppWebViewScreen.open(
                                context,
                                url: 'https://support.google.com/googleplay/answer/7018481?hl=en&co=GENIE.Platform%3DAndroid',
                              );
                            },
                            child: Text(
                              'How to Cancel Subscription',
                              style: GoogleFonts.nunito(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0284C7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Top-Right Close Button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const GameScreen()),
                      );
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF1E293B),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required bool isSelected,
    String? discount,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: Container(
        width: 154,
        height: 88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF4ADE80) : Colors.transparent,
            width: 3.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    price,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
            if (discount != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/src_assets_icons_60_discount.png',
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Image.asset(
      'assets/images/src_assets_icons_start_trial.png',
      height: 48,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF7CB5F9),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            Text(
              '7 Day Free Trial',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

