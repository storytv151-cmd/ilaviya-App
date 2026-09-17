import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Ads & Services
import 'ads/remote_config.dart';
import 'ads/ad_service.dart';
import 'ads/controller/ads_response_service.dart';
import 'core/storage/local_storage.dart';

// App Theme & Screens
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/splash/screens/splash_screen.dart';

// Optional: Uncomment when FCM or AuthRepository is configured
// import 'firebase_options.dart';
// import 'core/services/fcm_service.dart';
// import 'core/auth/auth_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
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

  // Initialize Firebase
  try {
    // If you have generated firebase_options.dart, you can use:
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initializeApp error / warning: $e");
  }

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initialize FCM and get token (uncomment once FCMService is added)
  // await FCMService.init();

  // Initialize client caches (shared_preferences)
  await LocalStorage.init();

  // Initialize Firebase Remote Config
  await SetupRemoteConfig();

  // Initialize GetStorage and Ads services
  await GetStorage.init();
  final adsResponseService = Get.put(AdsResponseService());
  await adsResponseService.getCreditEducationDetails();
  final adService = Get.put(AdService());
  await adService.initializeAds();

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
