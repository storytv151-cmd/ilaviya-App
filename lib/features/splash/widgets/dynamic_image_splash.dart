import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/splash/widgets/default_local_splash.dart';

/// Fullscreen Dynamic Image Splash Screen widget.
/// 
/// Preserves image aspect ratio, handles loading gracefully,
/// and delegates to fallback if the remote image fails to load.
class DynamicImageSplash extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onImageLoadFailed;

  const DynamicImageSplash({
    super.key,
    required this.imageUrl,
    this.onImageLoadFailed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashTheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with BoxFit.cover and graceful error fallback
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                return child;
              }
              // Show default local splash while buffering first frame
              return const DefaultLocalSplash();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const DefaultLocalSplash();
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('[DynamicImageSplash] Error loading image "$imageUrl": $error');
              if (onImageLoadFailed != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onImageLoadFailed!();
                });
              }
              return const DefaultLocalSplash();
            },
          ),

          // Subtle protective gradient overlay for system status bar & nav bar
          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: SplashTheme.darkOverlayGradient,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
