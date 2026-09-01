import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';

/// Trust & Customer Assurance Badges for ILAVIYA.
class TrustBadgesSection extends StatelessWidget {
  const TrustBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      {'icon': Icons.verified_outlined, 'title': '100% Authentic', 'sub': 'Pure Handcrafted'},
      {'icon': Icons.local_shipping_outlined, 'title': 'Free Shipping', 'sub': 'Across India'},
      {'icon': Icons.sync_alt_rounded, 'title': '7 Days Exchange', 'sub': 'Hassle-Free'},
      {'icon': Icons.support_agent_rounded, 'title': '24/7 Concierge', 'sub': 'Stylist Support'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFECEFF4),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item['icon'] as IconData,
                color: SplashTheme.goldPrimary,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                item['title'] as String,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF141720),
                ),
              ),
              Text(
                item['sub'] as String,
                style: const TextStyle(
                  fontSize: 8.5,
                  color: Color(0xFF8A91A0),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
