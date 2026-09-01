import 'package:flutter/material.dart';

/// Model representing a selectable language in ILAVIYA.
@immutable
class LanguageOption {
  final String code;
  final String title;
  final String nativeTitle;
  final String subtitle;
  final String badgeText;

  const LanguageOption({
    required this.code,
    required this.title,
    required this.nativeTitle,
    required this.subtitle,
    required this.badgeText,
  });

  static const List<LanguageOption> supportedLanguages = [
    LanguageOption(
      code: 'en',
      title: 'English',
      nativeTitle: 'English',
      subtitle: 'Default shopping experience',
      badgeText: 'EN',
    ),
    LanguageOption(
      code: 'gu',
      title: 'Gujarati',
      nativeTitle: 'ગુજરાતી',
      subtitle: 'તમારી પોતાની ભાષામાં ખરીદી કરો',
      badgeText: 'GU',
    ),
    LanguageOption(
      code: 'hi',
      title: 'Hindi',
      nativeTitle: 'हिन्दी',
      subtitle: 'अपनी पसंदीदा भाषा में खरीदारी करें',
      badgeText: 'HI',
    ),
    LanguageOption(
      code: 'mr',
      title: 'Marathi',
      nativeTitle: 'मराठी',
      subtitle: 'आपल्या पसंतीच्या भाषेत खरेदी करा',
      badgeText: 'MR',
    ),
    LanguageOption(
      code: 'bn',
      title: 'Bengali',
      nativeTitle: 'বাংলা',
      subtitle: 'আপনার পছন্দের ভাষায় কেনাকাটা করুন',
      badgeText: 'BN',
    ),
    LanguageOption(
      code: 'ta',
      title: 'Tamil',
      nativeTitle: 'தமிழ்',
      subtitle: 'உங்கள் விருப்பமான மொழியில் ஷாப்பிங் செய்யுங்கள்',
      badgeText: 'TA',
    ),
    LanguageOption(
      code: 'te',
      title: 'Telugu',
      nativeTitle: 'తెలుగు',
      subtitle: 'మీకు నచ్చిన భాషలో షాపింగ్ చేయండి',
      badgeText: 'TE',
    ),
    LanguageOption(
      code: 'kn',
      title: 'Kannada',
      nativeTitle: 'ಕನ್ನಡ',
      subtitle: 'ನಿಮ್ಮ ಮೆಚ್ಚಿನ ಭಾಷೆಯಲ್ಲಿ ಶಾಪಿಂಗ್ ಮಾಡಿ',
      badgeText: 'KN',
    ),
    LanguageOption(
      code: 'ml',
      title: 'Malayalam',
      nativeTitle: 'മലയാളം',
      subtitle: 'നിങ്ങളുടെ ഇഷ്ടഭാഷയിൽ ഷോപ്പിംഗ് ചെയ്യുക',
      badgeText: 'ML',
    ),
    LanguageOption(
      code: 'pa',
      title: 'Punjabi',
      nativeTitle: 'ਪੰਜਾਬੀ',
      subtitle: 'ਆਪਣੀ ਪਸੰਦੀਦਾ ਭਾਸ਼ਾ ਵਿੱਚ ਖਰੀਦਦਾਰੀ ਕਰੋ',
      badgeText: 'PA',
    ),
  ];
}
