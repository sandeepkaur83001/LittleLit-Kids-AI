import 'package:firebase_core/firebase_core.dart';
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

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: AppConstants.FIREBASE_API_KEY,
        appId: AppConstants.FIREBASE_APP_ID,
        messagingSenderId: AppConstants.FIREBASE_MESSAGING_SENDER_ID,
        projectId: AppConstants.FIREBASE_PROJECT_ID,
        storageBucket: AppConstants.FIREBASE_STORAGE_BUCKET,
      ),
    );
  } catch (e) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint("Firebase init warning: $e");
    }
  }

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
      title: 'LittleLit',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: initialTheme,
      home:  const SplashScreen(),
    );
  }
}
