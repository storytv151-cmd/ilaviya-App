import 'package:flutter/material.dart';

/// Single unified sweeping shimmer effect for cards and skeletons
class CosmicShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const CosmicShimmerEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<CosmicShimmerEffect> createState() => _CosmicShimmerEffectState();
}

class _CosmicShimmerEffectState extends State<CosmicShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final slide = _animation.value;
        final beginX = -2.5 + 3.5 * slide;
        final endX = -0.5 + 3.5 * slide;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(beginX, -0.3),
              end: Alignment(endX, 0.3),
              colors: const [
                Color(0xFF22223B),
                Color(0xFF22223B),
                Color(0xFF42426E),
                Color(0xFF6363A6),
                Color(0xFF42426E),
                Color(0xFF22223B),
                Color(0xFF22223B),
              ],
              stops: const [
                0.0,
                0.35,
                0.46,
                0.50,
                0.54,
                0.65,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Simple skeleton box element used inside [CosmicShimmerEffect]
class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? color;

  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF22223B),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Backward compatibility alias for [ShimmerBox]
class ShimmerContainer extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? color;

  const ShimmerContainer({
    super.key,
    required this.height,
    this.width,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      height: height,
      width: width,
      borderRadius: borderRadius,
      color: color,
    );
  }
}

/// Styled card shell for the small native ad shimmer
class SmallAdCardShell extends StatelessWidget {
  final Widget child;
  final double height;

  const SmallAdCardShell({
    super.key,
    required this.child,
    this.height = 135.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF151526),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E4A), width: 1),
      ),
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }
}

/// Shimmer skeleton matching the small native ad layout (135dp height)
class SmallNativeAdShimmer extends StatelessWidget {
  const SmallNativeAdShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const CosmicShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ad Badge
                    ShimmerBox(
                      height: 14,
                      width: 28,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 5),
                    // Headline
                    ShimmerBox(
                      height: 14,
                      width: 170,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 6),
                    // Body line 1
                    ShimmerBox(
                      height: 10,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    SizedBox(height: 4),
                    // Body line 2
                    ShimmerBox(
                      height: 10,
                      width: 120,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              // App Icon
              ShimmerBox(
                height: 56,
                width: 56,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ],
          ),
          // CTA button
          ShimmerBox(
            height: 34,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ],
      ),
    );
  }
}

/// Shimmer skeleton for large native ads
class LargeNativeAdShimmer extends StatelessWidget {
  const LargeNativeAdShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF151526),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E2E4A), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: const CosmicShimmerEffect(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              height: 160,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            SizedBox(height: 16),
            ShimmerBox(height: 20, width: 200),
            SizedBox(height: 10),
            ShimmerBox(height: 14),
            SizedBox(height: 6),
            ShimmerBox(height: 14, width: 220),
            SizedBox(height: 16),
            ShimmerBox(
              height: 44,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton for banner ads
class BannerAdShimmer extends StatelessWidget {
  const BannerAdShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const CosmicShimmerEffect(
      child: ShimmerBox(
        height: 50,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
