import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/ads_response_service.dart';
import 'mixins/banner_ad_mixin.dart';
import 'ad_shimmer_widgets.dart';
import 'ad_service.dart';
import 'unique_ad_widget.dart';

class BannerAdBuilder {
  static Widget buildBannerAd(GetxController controller, {bool isAlwaysShow = false}) {
    if (!Get.isRegistered<AdsResponseService>()) {
      return const SizedBox.shrink();
    }
    final adData = Get.find<AdsResponseService>().getCreditEducationData();
    if (adData != null && !adData.adStart) {
      return const SizedBox.shrink();
    }

    if (controller is! BannerAdMixin) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final bannerAd = controller.bannerAd.value;

      // Check frequency gating
      if (!isAlwaysShow) {
        if (!Get.find<AdService>().shouldShowBannerAd()) {
          return const SizedBox.shrink();
        }
      }

      if (bannerAd != null) {
        final w = bannerAd.size.width > 0 ? bannerAd.size.width.toDouble() : double.infinity;
        final h = bannerAd.size.height > 0 ? bannerAd.size.height.toDouble() : 50.0;
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          height: h,
          alignment: Alignment.center,
          child: SizedBox(
            width: w,
            height: h,
            child: UniqueAdWidget(ad: bannerAd),
          ),
        );
      }

/*
      // Facebook Fallback check
      if (controller.isBannerAdLoaded.value && bannerAd == null) {
        return const FacebookBannerAdWidget();
      }
*/

      if (controller.isBannerAdFailed.value) {
        return const SizedBox.shrink();
      }

      return const SizedBox(
        height: 50,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Center(child: BannerAdShimmer()),
        ),
      );
    });
  }
}

