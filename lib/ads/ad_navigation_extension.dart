import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ad_service.dart';

/// Extension on [BuildContext] to show interstitial ads on navigation
extension AdNavigation on BuildContext {
  /// Pushes a named route onto the navigation stack, showing an interstitial ad if eligible.
  void pushWithAd(String location, {Object? extra}) {
    if (!mounted) return;
    final adService = Get.isRegistered<AdService>() ? Get.find<AdService>() : null;
    if (adService == null) {
      Navigator.of(this).pushNamed(location, arguments: extra);
      return;
    }

    adService.showInterstitialAd(
      onComplete: () {
        if (mounted) {
          Navigator.of(this).pushNamed(location, arguments: extra);
        } else {
          final ctx = Get.key.currentContext;
          if (ctx != null) {
            Navigator.of(ctx).pushNamed(location, arguments: extra);
          }
        }
      },
    );
  }

  /// Pushes a Widget page onto the navigation stack, showing an interstitial ad if eligible.
  void pushWidgetWithAd(Widget page) {
    if (!mounted) return;
    final adService = Get.isRegistered<AdService>() ? Get.find<AdService>() : null;
    if (adService == null) {
      Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
      return;
    }

    adService.showInterstitialAd(
      onComplete: () {
        if (mounted) {
          Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
        } else {
          final ctx = Get.key.currentContext;
          if (ctx != null) {
            Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => page));
          }
        }
      },
    );
  }

  /// Replaces current route with a named route, showing an interstitial ad if eligible.
  void goWithAd(String location, {Object? extra}) {
    if (!mounted) return;
    final adService = Get.isRegistered<AdService>() ? Get.find<AdService>() : null;
    if (adService == null) {
      Navigator.of(this).pushReplacementNamed(location, arguments: extra);
      return;
    }

    adService.showInterstitialAd(
      onComplete: () {
        if (mounted) {
          Navigator.of(this).pushReplacementNamed(location, arguments: extra);
        } else {
          final ctx = Get.key.currentContext;
          if (ctx != null) {
            Navigator.of(ctx).pushReplacementNamed(location, arguments: extra);
          }
        }
      },
    );
  }
}
