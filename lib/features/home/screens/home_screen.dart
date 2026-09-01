import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/localization/locale_controller.dart';
import 'package:my_flutter_app/features/account/screens/account_screen.dart';
import 'package:my_flutter_app/features/ai_stylist/screens/ai_stylist_screen.dart';
import 'package:my_flutter_app/features/home/screens/shopify_webview_screen.dart';
import 'package:my_flutter_app/features/home/widgets/bottom_nav_bar.dart';
import 'package:my_flutter_app/features/reels/screens/fashion_reels_screen.dart';

/// Main Multi-Fragment Coordinator for ILAVIYA.
/// 
/// Smart Fragment Visibility:
/// - When user is at the Root Home of the website: Bottom Navigation is SHOWN.
/// - When user navigates into any inner product/category/cart page: Bottom Navigation is automatically HIDDEN for full-screen immersive shopping.
/// - When user navigates back to the root home page: Bottom Navigation is automatically RESTORED.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  bool _isAtWebViewRoot = true;

  @override
  Widget build(BuildContext context) {
    // Show bottom navigation if user is on other tabs (Reels, AI, Account)
    // OR if user is on Home tab and currently at the Root page of the store.
    final bool shouldShowBottomNav = (_currentNavIndex != 0) || _isAtWebViewRoot;

    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: _currentNavIndex,
            children: [
              ShopifyWebViewScreen(
                onRootStateChanged: (isRoot) {
                  if (mounted && _isAtWebViewRoot != isRoot) {
                    setState(() {
                      _isAtWebViewRoot = isRoot;
                    });
                  }
                },
              ),
              FashionReelsScreen(
                isActive: _currentNavIndex == 1,
              ),
              const AiStylistScreen(),
              const AccountScreen(),
            ],
          ),
          bottomNavigationBar: shouldShowBottomNav
              ? LuxuryBottomNavBar(
                  selectedIndex: _currentNavIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
                  },
                )
              : null,
        );
      },
    );
  }
}
