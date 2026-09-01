import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Constants and configuration values for the Splash Screen system.
class SplashConstants {
  SplashConstants._();

  /// Default API URL for fetching dynamic splash configuration.
  /// On Android emulator, '10.0.2.2' can be used if localhost fails,
  /// but 'http://localhost:5000/api/splash' is the primary target as requested.
  static const String defaultApiUrl = 'http://localhost:5000/api/splash';

  /// Returns the appropriate endpoint URL based on the runtime platform.
  static String get resolvedApiUrl {
    if (!kIsWeb && Platform.isAndroid) {
      // In local development on Android emulator, 10.0.2.2 maps to host localhost.
      // However, we support defaultApiUrl as primary while providing this helper.
      return defaultApiUrl;
    }
    return defaultApiUrl;
  }

  /// Strict maximum duration to wait for the splash API to respond.
  static const Duration apiTimeout = Duration(seconds: 5);

  /// Lower limit for splash duration to ensure the brand message is perceived.
  static const Duration minSplashDuration = Duration(seconds: 2);

  /// Upper limit for splash duration to prevent user frustration.
  static const Duration maxSplashDuration = Duration(seconds: 8);

  /// Default duration when API doesn't provide a duration or when using local splash.
  static const Duration defaultSplashDuration = Duration(milliseconds: 3500);

  /// Transition duration when animating to the main application.
  static const Duration transitionDuration = Duration(milliseconds: 600);

  /// Official Shopify Storefront Web URL
  static const String shopifyStoreUrl = 'https://ilaviya.com/';

  /// Modeling Reels API Endpoint URL
  static const String modelingReelsApiUrl = 'http://localhost:5000/api/reels';

  /// Returns the appropriate Reels endpoint URL based on runtime platform.
  static String get resolvedModelingReelsApiUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return modelingReelsApiUrl;
    }
    return modelingReelsApiUrl;
  }

  /// Brand identity constants
  static const String brandName = 'ILAVIYA';
  static const String brandTagline = 'ELEGANCE FOR EVERY WOMAN';
  static const String brandSubtext = 'HAUTE COUTURE • ELEVATED SHOPPING';
  static const String brandBadge = 'EXCLUSIVE COLLECTIONS';
  static const String brandYear = 'EST. 2026';
  static const String logoAsset = 'assets/images/ilaviya_logo.png';
}
