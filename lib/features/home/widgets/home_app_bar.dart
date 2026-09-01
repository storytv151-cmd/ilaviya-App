import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/localization/locale_controller.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/language/screens/language_screen.dart';

/// Luxury Header App Bar for ILAVIYA Home Screen.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int cartCount;
  final int wishlistCount;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onWishlistPressed;

  const HomeAppBar({
    super.key,
    this.cartCount = 2,
    this.wishlistCount = 4,
    this.onMenuPressed,
    this.onCartPressed,
    this.onWishlistPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final currentLang = LocaleController.instance.currentLanguageCode.toUpperCase();

        return AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          scrolledUnderElevation: 1.0,
          leading: IconButton(
            icon: const Icon(Icons.notes_rounded, color: Color(0xFF11141A), size: 26),
            onPressed: onMenuPressed,
          ),
          centerTitle: true,
          title: SizedBox(
            height: 38,
            child: Image.asset(
              SplashConstants.logoAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Text(
                SplashConstants.brandName,
                style: TextStyle(
                  color: Color(0xFF11141A),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3.5,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          actions: [
            // Language Switcher Badge (EN, GU, HI...)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LanguageScreen(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                decoration: BoxDecoration(
                  color: SplashTheme.goldSelectedBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: SplashTheme.goldPrimary,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.translate_rounded,
                      size: 13,
                      color: SplashTheme.goldDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      currentLang,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: SplashTheme.goldDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Wishlist Icon
            IconButton(
              icon: Badge(
                isLabelVisible: wishlistCount > 0,
                label: Text('$wishlistCount', style: const TextStyle(fontSize: 10)),
                backgroundColor: SplashTheme.goldPrimary,
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: Color(0xFF11141A),
                  size: 23,
                ),
              ),
              onPressed: onWishlistPressed,
            ),

            // Shopping Bag Icon
            IconButton(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
                backgroundColor: const Color(0xFF11141A),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF11141A),
                  size: 23,
                ),
              ),
              onPressed: onCartPressed,
            ),
            const SizedBox(width: 4),
          ],
        );
      },
    );
  }
}
