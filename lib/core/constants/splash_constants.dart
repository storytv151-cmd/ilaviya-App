import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Constants and configuration values for the Splash Screen system.
class SplashConstants {
  SplashConstants._();

  /// Live Backend API Base URL
  static const String apiBaseUrl = 'https://api.ilaviya.com';

  /// Default API URL for fetching dynamic splash configuration.
  static const String defaultApiUrl = '$apiBaseUrl/api/splash';

  /// Returns the appropriate endpoint URL based on the runtime platform.
  static String get resolvedApiUrl {
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
  static const String modelingReelsApiUrl = '$apiBaseUrl/api/reels';

  /// Returns the appropriate Reels endpoint URL based on runtime platform.
  static String get resolvedModelingReelsApiUrl {
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
