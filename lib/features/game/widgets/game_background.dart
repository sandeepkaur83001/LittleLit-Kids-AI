import 'package:little_kids_ai/core/common_imports.dart';

class GameBackground extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;
  final String? backgroundImage;
  final bool useSafeArea;

  const GameBackground({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.onBack,
    this.backgroundImage,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Stack(
      children: [
        if (showBackButton)
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        child,
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              backgroundImage ?? 'assets/images/splash_background_image.png',
              fit: BoxFit.cover,
            ),
          ),
          
          useSafeArea ? SafeArea(child: content) : content,
        ],
      ),
    );
  }
}
