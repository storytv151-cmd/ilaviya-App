import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'model/subscription_plan_model.dart';

const String defaultIAPPlansJson = '''
{
  "inAppData": [
    {
      "id": "astromonth",
      "name": "Monthly",
      "icon": "✨",
      "price": 0,
      "productId": "astro_pid",
      "planId": "astromonth",
      "isPopular": false,
      "features": [
        "🚫 Remove Ads",
        "🔮 Access All Astrology Features",
        "✨ Premium Astrology Experience",
        "📅 Monthly Subscription"
      ]
    },
    {
      "id": "astroyear01",
      "name": "Yearly",
      "icon": "👑",
      "price": 0,
      "productId": "astro_pid",
      "planId": "astroyear01",
      "isPopular": true,
      "features": [
        "🚫 Remove Ads",
        "🔮 Access All Astrology Features",
        "✨ Premium Astrology Experience",
        "👑 Best Value",
        "📅 Yearly Subscription"
      ]
    }
  ]
}
''';

Future<Map<String, dynamic>?> SetupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  try {
    await remoteConfig.ensureInitialized();
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: kReleaseMode
            ? const Duration(minutes: 1) // Standard for release
            : const Duration(seconds: 1), // Fast for testing
      ),
    );
    await remoteConfig.setDefaults({
      'ads_service': '',
      'iap_plans': defaultIAPPlansJson,
      'isPro': true,
      'isPremium': true,
    });
  } catch (e) {
    debugPrint("💰 [RemoteConfig] Settings error: $e");
  }

  // Fetch and activate
  try {
    final bool activated = await remoteConfig.fetchAndActivate();
    debugPrint("💰 [RemoteConfig] Activated: $activated");
  } catch (e) {
    debugPrint("💰 [RemoteConfig] Fetch/activate failed: $e");
  }

  return GetRemoteAdsService();
}

bool IsRemoteProConfigEnabled() {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    bool value = true;
    if (remoteConfig.getAll().containsKey('isPro')) {
      value = remoteConfig.getBool('isPro');
    } else if (remoteConfig.getAll().containsKey('isPremium')) {
      value = remoteConfig.getBool('isPremium');
    } else {
      value = remoteConfig.getBool('isPro');
    }
    debugPrint("💰 [RemoteConfig] Checked isPro/isPremium. Value: $value");
    return value;
  } catch (e) {
    debugPrint("💰 [RemoteConfig] Error reading isPro: $e");
    return true; // Default to true if error
  }
}

bool IsPremiumEnabled() => IsRemoteProConfigEnabled();

Map<String, dynamic>? GetRemoteAdsService() {
  try {
    final String adsService = FirebaseRemoteConfig.instance.getString('ads_service');
    if (adsService.isEmpty) return null;
    final decoded = json.decode(adsService);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
  } catch (e) {
    debugPrint("💰 [RemoteConfig] Error decoding ads_service: $e");
  }
  return null;
}

List<Map<String, dynamic>>? GetRemoteIAPPlans() {
  try {
    final String iapPlansString = FirebaseRemoteConfig.instance.getString('iap_plans');
    if (iapPlansString.isEmpty) return null;
    
    final decoded = json.decode(iapPlansString);
    List? plansList;
    
    if (decoded is Map && decoded.containsKey('inAppData')) {
      plansList = decoded['inAppData'] as List?;
    } else if (decoded is List) {
      plansList = decoded;
    }
    
    if (plansList != null) {
      return plansList.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  } catch (e) {
    debugPrint("💰 [RemoteConfig] Error decoding iap_plans: $e");
  }
  return null;
}

List<SubscriptionPlanModel> GetRemoteSubscriptionPlans() {
  final plansMap = GetRemoteIAPPlans();
  if (plansMap != null && plansMap.isNotEmpty) {
    return plansMap.map((m) => SubscriptionPlanModel.fromJson(m)).toList();
  }
  try {
    final decoded = json.decode(defaultIAPPlansJson);
    final list = decoded['inAppData'] as List;
    return list
        .map((e) => SubscriptionPlanModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } catch (e) {
    debugPrint("💰 [RemoteConfig] Error parsing default subscription plans: $e");
    return [];
  }
}

