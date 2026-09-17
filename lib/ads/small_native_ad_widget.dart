import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'unique_ad_widget.dart';

class SmallNativeAdWidget extends StatelessWidget {
  final NativeAd nativeAd;
  final double height;

  const SmallNativeAdWidget({
    super.key,
    required this.nativeAd,
    this.height = 135.0,
  });

  @override
  Widget build(BuildContext context) {
    // If we're on Android, we check responseInfo as a final safety check
    // to prevent "id could not be found: 0" which happens if the native side
    // hasn't fully registered the ad handle yet.
    if (nativeAd.responseInfo == null) {
      return SizedBox(height: height);
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: UniqueAdWidget(ad: nativeAd),
    );
  }
}