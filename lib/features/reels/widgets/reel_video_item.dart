import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/home/screens/shopify_webview_screen.dart';
import 'package:my_flutter_app/features/reels/models/reel_model.dart';
import 'package:video_player/video_player.dart';

/// Single Reel Video Item with playback controls, animated interactions, and Shopify product checkout.
class ReelVideoItem extends StatefulWidget {
  final ReelModel reel;
  final bool isCurrent;

  const ReelVideoItem({
    super.key,
    required this.reel,
    required this.isCurrent,
  });

  @override
  State<ReelVideoItem> createState() => _ReelVideoItemState();
}

class _ReelVideoItemState extends State<ReelVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLiked = false;
  late int _likesCount;
  bool _showHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isCurrent;
    _likesCount = widget.reel.likes;
    _initVideo();
  }

  void _initVideo() {
    if (widget.reel.videoUrl.isEmpty) return;

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.reel.videoUrl),
      )..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _controller?.setLooping(true);
            if (widget.isCurrent) {
              _controller?.play();
              setState(() {
                _isPlaying = true;
              });
            } else {
              _controller?.pause();
              setState(() {
                _isPlaying = false;
              });
            }
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _isInitialized = false;
            });
          }
        });
    } catch (_) {
      // Handled safely
    }
  }

  @override
  void didUpdateWidget(covariant ReelVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reel.videoUrl != oldWidget.reel.videoUrl) {
      _controller?.pause();
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
      _initVideo();
    } else if (widget.isCurrent != oldWidget.isCurrent) {
      if (widget.isCurrent) {
        _controller?.play();
        setState(() {
          _isPlaying = true;
        });
      } else {
        _controller?.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  void _onDoubleTap() {
    setState(() {
      if (!_isLiked) {
        _isLiked = true;
        _likesCount++;
      }
      _showHeartAnimation = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _showHeartAnimation = false;
        });
      }
    });
  }

  void _openProductCheckout() {
    final targetUrl = widget.reel.productUrl.isNotEmpty
        ? widget.reel.productUrl
        : SplashConstants.shopifyStoreUrl;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShopifyWebViewScreen(
          initialUrl: targetUrl,
        ),
      ),
    );
  }

  void _shareReel() {
    final title = widget.reel.productTitle.isNotEmpty ? widget.reel.productTitle : widget.reel.caption;
    final url = widget.reel.productUrl.isNotEmpty ? widget.reel.productUrl : SplashConstants.shopifyStoreUrl;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1B1F2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(Icons.share, color: SplashTheme.goldPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sharing: $title\n$url',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posterImage = widget.reel.thumbnailUrl ?? widget.reel.productImageUrl;

    return GestureDetector(
      onTap: _togglePlayPause,
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Video Background or High-res Poster Fallback
          Container(
            color: Colors.black,
            child: _isInitialized && _controller != null
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      if (posterImage.isNotEmpty)
                        Image.network(
                          posterImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: const Color(0xFF141824)),
                        )
                      else
                        Container(color: const Color(0xFF141824)),
                      const Center(
                        child: CircularProgressIndicator(
                          color: SplashTheme.goldPrimary,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ],
                  ),
          ),

          // 2. Gradient Overlay for Text Readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x55000000),
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xCC000000),
                ],
                stops: [0.0, 0.25, 0.65, 1.0],
              ),
            ),
          ),

          // 3. Play/Pause Big Center Indicator
          if (!_isPlaying && _isInitialized)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),

          // 4. Double Tap Heart Burst Animation
          if (_showHeartAnimation)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1.3),
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: const Icon(
                      Icons.favorite,
                      size: 90,
                      color: Color(0xFFE53935),
                    ),
                  );
                },
              ),
            ),

          // 5. Right Floating Action Buttons (Likes, Comments, Share)
          Positioned(
            right: 14,
            bottom: 110,
            child: Column(
              children: [
                // Like Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _likesCount += _isLiked ? 1 : -1;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: _isLiked ? const Color(0xFFE53935) : Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_likesCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Comment Button
                Column(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.reel.comments}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Share Button
                GestureDetector(
                  onTap: _shareReel,
                  child: const Column(
                    children: [
                      Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. Bottom Information & "Shop Look" Interactive Banner
          Positioned(
            left: 16,
            right: 76,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Model Name & Verified Tag
                Row(
                  children: [
                    Text(
                      widget.reel.modelName,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      size: 15,
                      color: SplashTheme.goldPrimary,
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Description / Caption
                Text(
                  widget.reel.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 4),

                // Hashtags
                Text(
                  widget.reel.tag,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: SplashTheme.goldLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // "Shop This Look" Glassmorphic Product Card
                GestureDetector(
                  onTap: _openProductCheckout,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 38,
                            height: 38,
                            child: Image.network(
                              widget.reel.productImageUrl,
                              width: 38,
                              height: 38,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFF0F2F6),
                                child: const Icon(Icons.photo, size: 18, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.reel.productTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF141720),
                                ),
                              ),
                              Text(
                                widget.reel.product?.formattedPrice ?? '₹${widget.reel.productPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: SplashTheme.goldDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: SplashTheme.goldGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'BUY NOW',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111111),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
