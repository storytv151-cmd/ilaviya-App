import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/splash/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set transparent system navigation / status bar for clean light luxury theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const IlaviyaApp());
}

/// Root Application Widget.
class IlaviyaApp extends StatelessWidget {
  const IlaviyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: SplashConstants.brandName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SplashTheme.goldPrimary,
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
