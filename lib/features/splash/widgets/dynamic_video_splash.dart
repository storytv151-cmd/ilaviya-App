import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/splash/widgets/default_local_splash.dart';
import 'package:my_flutter_app/features/splash/widgets/dynamic_image_splash.dart';

/// Fullscreen Dynamic Video Splash Screen widget.
/// 
/// Handles muted autoplay, aspect-ratio cover fitting, clean controller lifecycle,
/// and automatic fallback to fallbackImageUrl or default splash on playback error.
class DynamicVideoSplash extends StatefulWidget {
  final String videoUrl;
  final String? fallbackImageUrl;
  final VoidCallback? onVideoFailed;

  const DynamicVideoSplash({
    super.key,
    required this.videoUrl,
    this.fallbackImageUrl,
    this.onVideoFailed,
  });

  @override
  State<DynamicVideoSplash> createState() => _DynamicVideoSplashState();
}

class _DynamicVideoSplashState extends State<DynamicVideoSplash> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final uri = Uri.parse(widget.videoUrl);
      final controller = VideoPlayerController.networkUrl(
        uri,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _controller = controller;

      await controller.initialize();
      await controller.setVolume(0.0); // Muted by requirement
      await controller.setLooping(true);
      await controller.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('[DynamicVideoSplash] Failed to load/play video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
        widget.onVideoFailed?.call();
      }
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      if (widget.fallbackImageUrl != null && widget.fallbackImageUrl!.isNotEmpty) {
        return DynamicImageSplash(
          imageUrl: widget.fallbackImageUrl!,
          onImageLoadFailed: widget.onVideoFailed,
        );
      }
      return const DefaultLocalSplash();
    }

    if (!_isInitialized || _controller == null) {
      // If fallback image exists while video initializes, we can display it or the default local splash
      if (widget.fallbackImageUrl != null && widget.fallbackImageUrl!.isNotEmpty) {
        return DynamicImageSplash(imageUrl: widget.fallbackImageUrl!);
      }
      return const DefaultLocalSplash();
    }

    final videoSize = _controller!.value.size;

    return Scaffold(
      backgroundColor: SplashTheme.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fullscreen Video with BoxFit.cover
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: SizedBox(
                width: videoSize.width > 0 ? videoSize.width : 16,
                height: videoSize.height > 0 ? videoSize.height : 9,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),

          // Protective overlay gradient for system status and navigation bar
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
