import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'unique_ad_widget.dart';

class LargeNativeAdWidget extends StatelessWidget {
  final NativeAd nativeAd;

  const LargeNativeAdWidget({super.key, required this.nativeAd});

  @override
  Widget build(BuildContext context) {
    // Safety check for native ad handle readiness
    if (nativeAd.responseInfo == null) {
      return const SizedBox(height: 320); 
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF151526),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E4A), width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 320,
        child: UniqueAdWidget(ad: nativeAd),
      ),
    );
  }
}
