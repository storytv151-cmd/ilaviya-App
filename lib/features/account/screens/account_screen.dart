import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/localization/locale_controller.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/language/screens/language_screen.dart';

/// User Account & Profile Screen for ILAVIYA.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final activeLocale = LocaleController.instance;

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: const Text(
              'MY ACCOUNT',
              style: TextStyle(
                color: Color(0xFF11141A),
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5,
                fontSize: 16,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                // 1. User Profile Header Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFECEFF4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SplashTheme.goldGradient,
                        ),
                        child: const Center(
                          child: Text(
                            'IA',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111111),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Valued Customer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF11141A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'VIP Royal Member • ILAVIYA Club',
                              style: TextStyle(
                                fontSize: 12,
                                color: SplashTheme.goldDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF6B7280)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 2. Quick Order & Wishlist Action Bar
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionBox(
                        icon: Icons.local_shipping_outlined,
                        title: 'My Orders',
                        subtitle: 'Track / Return',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionBox(
                        icon: Icons.favorite_border_rounded,
                        title: 'Wishlist',
                        subtitle: '4 Saved Items',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 3. Settings & Language Preferences
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFECEFF4)),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.translate_rounded,
                        title: activeLocale.tr('language'),
                        subtitle: '${activeLocale.currentLanguageCode.toUpperCase()} • Active',
                        trailingBadge: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: SplashTheme.goldSelectedBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: SplashTheme.goldPrimary, width: 0.8),
                          ),
                          child: Text(
                            activeLocale.currentLanguageCode.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: SplashTheme.goldDark,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const LanguageScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Saved Delivery Addresses',
                        subtitle: 'Home, Office',
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildMenuItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications & Alerts',
                        subtitle: 'Offers, Order updates',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 4. Concierge & Support
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFECEFF4)),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.support_agent_rounded,
                        title: '24/7 Royal Concierge',
                        subtitle: 'WhatsApp & Call Assistance',
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildMenuItem(
                        icon: Icons.shield_outlined,
                        title: 'About ${SplashConstants.brandName}',
                        subtitle: SplashConstants.brandTagline,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Sign Out Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout_rounded, color: Color(0xFFD32F2F), size: 18),
                    label: const Text(
                      'SIGN OUT',
                      style: TextStyle(
                        color: Color(0xFFD32F2F),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionBox({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFECEFF4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: SplashTheme.goldPrimary, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF11141A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFF8C93A4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailingBadge,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: SplashTheme.goldDark, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF141720)),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11.5, color: Color(0xFF8C93A4)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?trailingBadge,
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFFB0B7C3)),
        ],
      ),
    );
  }
}
