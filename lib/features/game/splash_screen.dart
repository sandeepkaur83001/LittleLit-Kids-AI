import 'dart:async';

import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/auth_choice_screen.dart';

import 'package:little_kids_ai/features/game/game_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authController = Get.find<AuthController>();
    final isLoggedIn = await authController.checkAuthStatus();

    if (!mounted) return;

    if (isLoggedIn) {
      // Also fetch latest profile in background
      Get.find<ProfileController>().fetchProfile();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthChoiceScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_background_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
