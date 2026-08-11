import 'package:flutter/services.dart';
import 'package:little_kids_ai/features/game/splash_screen.dart';
import 'package:little_kids_ai/core/common_imports.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set orientation to landscape only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set full screen mode for the game
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  DependencyInjection.init();
  await DeviceInfoUtil.init();

  await PushNotifications.localNotificationInit();
  await PushNotifications().requestNotificationPermission();

  ThemeMode initialTheme = await ThemeService.getInitialTheme();
  
  runApp(MyApp(initialTheme: initialTheme));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  const MyApp({super.key, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: initialTheme,
      home:  const SplashScreen(),
    );
  }
}
