import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/localization/locale_controller.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/home/screens/home_screen.dart';
import 'package:my_flutter_app/features/language/models/language_option.dart';
import 'package:my_flutter_app/features/language/services/language_service.dart';

/// Luxury Language Selection Screen for ILAVIYA.
/// 
/// Supports 10 major Indian languages with real-time, instant UI translation updates
/// as soon as any language is tapped.
class LanguageScreen extends StatefulWidget {
  final Widget? nextScreen;

  const LanguageScreen({
    super.key,
    this.nextScreen,
  });

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onLanguageSelected(String code) {
    LocaleController.instance.changeLanguage(code);
  }

  Future<void> _onContinue() async {
    await LanguageService.saveLanguage(LocaleController.instance.currentLanguageCode);
    if (!mounted) return;

    final destination = widget.nextScreen ?? const HomeScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 680;

    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final activeLocale = LocaleController.instance;
        final selectedCode = activeLocale.currentLanguageCode;

        final filteredLanguages = LanguageOption.supportedLanguages.where((l) {
          if (_searchQuery.isEmpty) return true;
          final query = _searchQuery.toLowerCase();
          return l.title.toLowerCase().contains(query) ||
              l.nativeTitle.toLowerCase().contains(query) ||
              l.badgeText.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          backgroundColor: SplashTheme.background,
          body: Stack(
            children: [
              // 1. Ambient Background Layer
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: SplashTheme.backgroundGradient,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: SplashTheme.ambientGlow,
                    ),
                  ),
                ),
              ),

              // 2. Main Content Container
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 10 : 20),

                      // Golden Brand Logo Header
                      SizedBox(
                        height: isSmallScreen ? 55 : 68,
                        child: Image.asset(
                          SplashConstants.logoAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Text(
                            SplashConstants.brandName,
                            style: SplashTheme.brandTitleStyle.copyWith(fontSize: 22),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 20),

                      // Live Dynamic Localized Header Titles
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          activeLocale.tr('select_language_title'),
                          key: ValueKey('title_${activeLocale.currentLanguageCode}'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: SplashTheme.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          activeLocale.tr('select_language_subtitle'),
                          key: ValueKey('sub_${activeLocale.currentLanguageCode}'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: SplashTheme.goldPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 14 : 20),

                      // Search Input Filter
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFECEFF3),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val.trim();
                            });
                          },
                          style: const TextStyle(
                            color: SplashTheme.textPrimary,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search language / ભાષા શોધો...',
                            hintStyle: const TextStyle(
                              color: SplashTheme.textTertiary,
                              fontSize: 12.5,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 18,
                              color: SplashTheme.goldPrimary,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: SplashTheme.textTertiary,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 11,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Scrollable Language Option Cards List
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredLanguages.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final option = filteredLanguages[index];
                            final isSelected = selectedCode == option.code;

                            return _buildLanguageCard(
                              option: option,
                              isSelected: isSelected,
                              onTap: () => _onLanguageSelected(option.code),
                            );
                          },
                        ),
                      ),

                      // Bottom Sticky Action Button (Instant Live Translated Text)
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: isSmallScreen ? 14 : 24,
                        ),
                        child: _buildContinueButton(activeLocale.tr('continue_btn')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageCard({
    required LanguageOption option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected
            ? SplashTheme.goldSelectedBg
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? SplashTheme.goldPrimary
              : const Color(0xFFECEFF3),
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? SplashTheme.goldPrimary.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isSelected ? 14 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: SplashTheme.goldPrimary.withValues(alpha: 0.12),
          highlightColor: SplashTheme.goldPrimary.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                // Circular Region Badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? SplashTheme.goldPrimary
                        : const Color(0xFFF3F5F8),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    option.badgeText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : SplashTheme.goldDark,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Native and English Titles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            option.nativeTitle,
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? SplashTheme.textPrimary
                                  : SplashTheme.textSecondary,
                            ),
                          ),
                          if (option.title != option.nativeTitle) ...[
                            const SizedBox(width: 8),
                            Text(
                              '(${option.title})',
                              style: const TextStyle(
                                fontSize: 12,
                                color: SplashTheme.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isSelected
                              ? SplashTheme.goldLight
                              : SplashTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Radio Checkbox Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? SplashTheme.goldPrimary
                          : SplashTheme.textTertiary,
                      width: 1.8,
                    ),
                    color: isSelected
                        ? SplashTheme.goldPrimary
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 13,
                          color: Color(0xFF111111),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(String buttonText) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          gradient: SplashTheme.goldGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: SplashTheme.goldPrimary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  buttonText,
                  key: ValueKey(buttonText),
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Color(0xFF111111),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
