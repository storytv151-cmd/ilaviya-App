import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';

/// Luxury 4-Fragment Bottom Navigation Bar for ILAVIYA.
/// Uses SafeArea so icons & text are perfectly placed above phone navigation buttons,
/// while maintaining a sleek, compact height.
class LuxuryBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onItemSelected;

  const LuxuryBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFECEFF3),
            width: 0.9,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.storefront_rounded, Icons.storefront_outlined, 'Home', key: const Key('nav_home')),
              _buildNavItem(1, Icons.play_circle_fill_rounded, Icons.play_circle_outline_rounded, 'Reels', key: const Key('nav_reels')),
              _buildNavItem(2, Icons.auto_awesome_rounded, Icons.auto_awesome_outlined, 'AI Stylist', key: const Key('nav_ai')),
              _buildNavItem(3, Icons.person_rounded, Icons.person_outline_rounded, 'Account', key: const Key('nav_account')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label, {
    Key? key,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      key: key,
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 21,
              color: isSelected ? SplashTheme.goldDark : const Color(0xFF7A8293),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? SplashTheme.goldDark : const Color(0xFF7A8293),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
