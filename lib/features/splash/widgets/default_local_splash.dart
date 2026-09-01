import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/splash/widgets/splash_brand_logo.dart';

/// Premium, luxury e-commerce default splash screen for ILAVIYA.
/// 
/// Features:
/// - Smooth entrance transitions.
/// - Continuous, fluid luxury metallic gold loading animation with pulsing sparkle stars.
/// - Responsive scaling for all device sizes.
class DefaultLocalSplash extends StatefulWidget {
  const DefaultLocalSplash({super.key});

  @override
  State<DefaultLocalSplash> createState() => _DefaultLocalSplashState();
}

class _DefaultLocalSplashState extends State<DefaultLocalSplash>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _loadingController;
  late final AnimationController _pulseController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _shimmerSweep;
  late final Animation<double> _pulseGlow;

  @override
  void initState() {
    super.initState();

    // 1. Initial Entry Animation (Runs once smoothly on launch)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.70, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Continuous Fluid Loading Animation (Infinite smooth loop)
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _shimmerSweep = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOutSine,
    );

    // 3. Subtle Breathing Halo Glow (Infinite breathing pulse)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseGlow = Tween<double>(begin: 0.35, end: 0.95).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _loadingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 650;
    final logoWidth = isSmallScreen ? size.width * 0.74 : size.width * 0.82;

    return Scaffold(
      backgroundColor: SplashTheme.background,
      body: Stack(
        children: [
          // 1. Ambient Background Layer with Luxury Radial Gold Halo
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: SplashTheme.backgroundGradient,
              ),
              child: AnimatedBuilder(
                animation: _pulseGlow,
                builder: (context, _) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.9,
                        colors: [
                          SplashTheme.goldPrimary.withValues(
                            alpha: 0.07 * _pulseGlow.value,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Year Badge (Top Corner)
          Positioned(
            top: 40,
            right: 24,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                SplashConstants.brandYear,
                style: SplashTheme.badgeTextStyle.copyWith(
                  color: SplashTheme.textTertiary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),

          // 3. Main Brand Hero Section
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Official Brand Logo Display
                            SizedBox(
                              width: logoWidth.clamp(260.0, 360.0),
                              child: Image.asset(
                                SplashConstants.logoAsset,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SplashBrandLogo(size: 90),
                                      const SizedBox(height: 16),
                                      Text(
                                        SplashConstants.brandName,
                                        style: SplashTheme.brandTitleStyle,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        SplashConstants.brandTagline,
                                        style: SplashTheme.brandSubtitleStyle,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 28),

                            // Luxury E-commerce Capsule Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: SplashTheme.goldPrimary.withValues(alpha: 0.35),
                                  width: 0.9,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 13,
                                    color: SplashTheme.goldPrimary,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    SplashConstants.brandBadge,
                                    style: SplashTheme.badgeTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 4. Bottom Fluid Luxury Loading Bar & Star Indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: isSmallScreen ? 24 : 44,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Luxury Loader Container
                  _buildFluidLuxuryLoader(),

                  const SizedBox(height: 16),

                  // Subtext
                  const Text(
                    SplashConstants.brandSubtext,
                    style: SplashTheme.footerTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a fluid, sweeping golden metallic loading indicator with glowing stars.
  Widget _buildFluidLuxuryLoader() {
    return AnimatedBuilder(
      animation: Listenable.merge([_loadingController, _pulseController]),
      builder: (context, _) {
        final progress = _shimmerSweep.value; // 0.0 -> 1.0 smooth sine
        final pulse = _pulseGlow.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Sparkling Star
            Transform.rotate(
              angle: _loadingController.value * math.pi * 2,
              child: Icon(
                Icons.star_rate_rounded,
                size: 14,
                color: SplashTheme.goldPrimary.withValues(alpha: 0.4 + 0.5 * pulse),
              ),
            ),

            const SizedBox(width: 12),

            // Continuous Sweeping Gold Progress Capsule Track
            Container(
              width: 110,
              height: 3.5,
              decoration: BoxDecoration(
                color: const Color(0xFFEBEFF4),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    // Moving Shimmer Gradient
                    FractionalTranslation(
                      translation: Offset(-1.0 + (progress * 2.0), 0.0),
                      child: Container(
                        width: 55,
                        height: 3.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              SplashTheme.goldLight.withValues(alpha: 0.1),
                              SplashTheme.goldPrimary,
                              SplashTheme.goldLight,
                              SplashTheme.goldPrimary,
                              SplashTheme.goldLight.withValues(alpha: 0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SplashTheme.goldPrimary.withValues(alpha: 0.6 * pulse),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Right Sparkling Star
            Transform.rotate(
              angle: -_loadingController.value * math.pi * 2,
              child: Icon(
                Icons.star_rate_rounded,
                size: 14,
                color: SplashTheme.goldPrimary.withValues(alpha: 0.4 + 0.5 * pulse),
              ),
            ),
          ],
        );
      },
    );
  }
}
