import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ad_service.dart';
import '../controller/ads_response_service.dart';

mixin InterstitialAdMixin on GetxController {
  final AdsResponseService adsResponseService = Get.find<AdsResponseService>();
  AdService get _adService => Get.find<AdService>();

  final RxBool isInterstitialAdLoaded = false.obs;

  /// Load interstitial ad
  Future<void> loadInterstitialAd({bool isFallback = false}) async {
    await _adService.loadInterstitialAd(isFallback: isFallback);
    isInterstitialAdLoaded.value = _adService.isInterstitialAdReady;
  }

  /// Load interstitial ad bypassing frequency gating
  void loadInterstitialAdAlways() {
    loadInterstitialAd();
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd({
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailed,
    bool waitForDismiss = false,
    bool force = false,
  }) async {
    return _adService.showInterstitialAd(
      onComplete: onAdDismissed,
      force: force,
    );
  }

  Future<void> navigateWithInterstitialAd(String route, {Map<String, dynamic>? data}) async {
    await showInterstitialAd(
      onAdDismissed: () => Get.toNamed(route, arguments: data),
      onAdFailed: () => Get.toNamed(route, arguments: data),
    );
  }

  void disposeInterstitialAd() {}

  @override
  void onClose() {
    disposeInterstitialAd();
    super.onClose();
  }
}
