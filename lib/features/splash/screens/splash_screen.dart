import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/features/home/screens/home_screen.dart';
import 'package:my_flutter_app/features/home/services/shopify_webview_preloader.dart';
import 'package:my_flutter_app/features/language/screens/language_screen.dart';
import 'package:my_flutter_app/features/language/services/language_service.dart';
import 'package:my_flutter_app/features/splash/models/splash_model.dart';
import 'package:my_flutter_app/features/splash/services/splash_api_service.dart';
import 'package:my_flutter_app/features/splash/widgets/default_local_splash.dart';
import 'package:my_flutter_app/features/splash/widgets/dynamic_image_splash.dart';
import 'package:my_flutter_app/features/splash/widgets/dynamic_video_splash.dart';

enum _SplashViewState {
  defaultLocal,
  dynamicImage,
  dynamicVideo,
}

/// The primary Splash Screen orchestrator for ILAVIYA.
/// 
/// Manages the full lifecycle:
/// 1. Immediately presents default local splash.
/// 2. Asynchronously queries the Splash API & preloads the WebView in the background.
/// 3. Pre-caches and renders dynamic media if active.
/// 4. Waits until minimum splash branding time AND background WebView are ready.
/// 5. Seamlessly transitions to Home Screen without any white flash or loading delays.
class SplashScreen extends StatefulWidget {
  final SplashApiService? apiService;
  final Widget? destinationScreen;

  const SplashScreen({
    super.key,
    this.apiService,
    this.destinationScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashApiService _apiService;
  late final DateTime _startTime;

  _SplashViewState _viewState = _SplashViewState.defaultLocal;
  SplashData? _splashData;
  Duration _activeDuration = const Duration(milliseconds: 1500);
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _apiService = widget.apiService ?? SplashApiService();
    
    // Start background preloading of Shopify storefront WebView immediately
    ShopifyWebViewPreloader.instance.preload();
    _initSplashFlow();
  }

  @override
  void dispose() {
    // Only dispose if we created our own service instance
    if (widget.apiService == null) {
      _apiService.dispose();
    }
    super.dispose();
  }

  /// Coordinates asynchronous API retrieval, precaching, background WebView preloading, and smooth navigation.
  Future<void> _initSplashFlow() async {
    try {
      final splashData = await _apiService.fetchSplashData();

      if (!mounted || _hasNavigated) return;

      if (splashData != null) {
        _splashData = splashData;
        _activeDuration = splashData.duration;

        if (splashData.type == SplashType.image) {
          // Pre-cache remote image before displaying to eliminate flicker
          bool precached = false;
          try {
            await precacheImage(NetworkImage(splashData.mediaUrl), context);
            precached = true;
          } catch (e) {
            debugPrint('[SplashScreen] Image precache failed: $e');
            precached = false;
          }

          if (mounted && !_hasNavigated && precached) {
            setState(() {
              _viewState = _SplashViewState.dynamicImage;
            });
          }
        } else if (splashData.type == SplashType.video) {
          if (mounted && !_hasNavigated) {
            setState(() {
              _viewState = _SplashViewState.dynamicVideo;
            });
          }
        }
      } else {
        _activeDuration = const Duration(milliseconds: 1500);
      }
    } catch (e) {
      debugPrint('[SplashScreen] Unexpected error during splash flow: $e');
      _activeDuration = const Duration(milliseconds: 1500);
    }

    if (!mounted || _hasNavigated) return;

    // 1. Wait for minimum branding display or dynamic media duration
    final elapsed = DateTime.now().difference(_startTime);
    final remaining = _activeDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (!mounted || _hasNavigated) return;

    // 2. Wait until background WebView has completed loading (or safe timeout/error)
    await ShopifyWebViewPreloader.instance.waitUntilReady(
      timeout: const Duration(seconds: 5),
    );

    if (!mounted || _hasNavigated) return;

    // 3. Smoothly navigate to Home / Language screen
    await _navigateToNextScreen();
  }

  void _onMediaFailed() {
    if (!mounted || _hasNavigated) return;
    setState(() {
      _viewState = _SplashViewState.defaultLocal;
    });
  }

  /// Performs smooth route transition to the main application.
  Future<void> _navigateToNextScreen() async {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    Widget destination;
    if (widget.destinationScreen != null) {
      destination = widget.destinationScreen!;
    } else {
      final hasSelected = await LanguageService.hasSelectedLanguage();
      destination = hasSelected ? const HomeScreen() : const LanguageScreen();
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: SplashConstants.transitionDuration,
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
    Widget activeContent;

    switch (_viewState) {
      case _SplashViewState.dynamicImage:
        activeContent = DynamicImageSplash(
          imageUrl: _splashData!.mediaUrl,
          onImageLoadFailed: _onMediaFailed,
        );
        break;

      case _SplashViewState.dynamicVideo:
        activeContent = DynamicVideoSplash(
          videoUrl: _splashData!.mediaUrl,
          fallbackImageUrl: _splashData!.fallbackImageUrl,
          onVideoFailed: _onMediaFailed,
        );
        break;

      case _SplashViewState.defaultLocal:
        activeContent = const DefaultLocalSplash();
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: KeyedSubtree(
        key: ValueKey<int>(_viewState.index),
        child: activeContent,
      ),
    );
  }
}
