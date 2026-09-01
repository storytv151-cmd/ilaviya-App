import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Preloads and manages the primary Shopify Storefront WebViewController
/// in the background during Splash Screen so that the website is already
/// fully loaded before navigating to the Home Screen.
class ShopifyWebViewPreloader {
  ShopifyWebViewPreloader._internal();

  static final ShopifyWebViewPreloader instance = ShopifyWebViewPreloader._internal();

  WebViewController? _controller;
  bool _isPreloading = false;
  bool _isReady = false;
  int _loadingProgress = 0;
  bool _hasError = false;
  String _errorMessage = '';
  Completer<void>? _readyCompleter;
  Timer? _safetyTimeoutTimer;

  // Active listener callbacks for the mounted ShopifyWebViewScreen
  ValueChanged<int>? onProgressChanged;
  ValueChanged<String>? onPageStarted;
  ValueChanged<String>? onPageFinished;
  ValueChanged<UrlChange>? onUrlChanged;
  void Function(bool hasError, String message)? onErrorChanged;

  /// Returns the pre-initialized WebViewController.
  WebViewController? get controller => _controller;

  /// Whether the web page is fully loaded and ready to display.
  bool get isReady => _isReady;

  /// Current loading progress percentage (0 - 100).
  int get loadingProgress => _loadingProgress;

  /// Whether a main frame loading error occurred.
  bool get hasError => _hasError;

  /// Error description if loading failed.
  String get errorMessage => _errorMessage;

  /// Starts preloading the Shopify Storefront URL in the background.
  void preload({String? url}) {
    // If already preloaded or currently preloading with a controller, keep it
    if (_isPreloading && _controller != null) {
      return;
    }

    _isPreloading = true;
    _isReady = false;
    _hasError = false;
    _errorMessage = '';
    _loadingProgress = 0;
    _readyCompleter = Completer<void>();

    try {
      final targetUrl = url ?? SplashConstants.shopifyStoreUrl;

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              _loadingProgress = progress;
              onProgressChanged?.call(progress);

              // If progress reached 80%+, the DOM is usable
              if (progress >= 80 && !_isReady) {
                _markReady();
              }
            },
            onPageStarted: (String startedUrl) {
              _hasError = false;
              _errorMessage = '';
              _loadingProgress = 10;
              onPageStarted?.call(startedUrl);
            },
            onPageFinished: (String finishedUrl) {
              _loadingProgress = 100;
              _markReady();
              onPageFinished?.call(finishedUrl);
            },
            onUrlChange: (UrlChange change) {
              onUrlChanged?.call(change);
            },
            onWebResourceError: (WebResourceError error) {
              if (error.isForMainFrame == true) {
                _hasError = true;
                _errorMessage = error.description;
                _markReady(); // Complete ready so splash does not hang on network error
                onErrorChanged?.call(true, error.description);
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(targetUrl));

      _controller = controller;

      // Safety timeout: Ensure splash screen never hangs indefinitely
      _safetyTimeoutTimer?.cancel();
      _safetyTimeoutTimer = Timer(const Duration(seconds: 6), () {
        if (!_isReady) {
          if (kDebugMode) {
            print('[ShopifyWebViewPreloader] Safety timeout reached, marking ready.');
          }
          _markReady();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('[ShopifyWebViewPreloader] Preload error: $e');
      }
      _hasError = true;
      _errorMessage = e.toString();
      _markReady();
    }
  }

  void _markReady() {
    _isReady = true;
    _safetyTimeoutTimer?.cancel();
    if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
      _readyCompleter!.complete();
    }
  }

  /// Waits until the WebView is loaded, failed, or timed out.
  Future<void> waitUntilReady({Duration timeout = const Duration(seconds: 6)}) async {
    if (_isReady || _hasError || _controller == null) {
      return;
    }

    if (_readyCompleter != null) {
      try {
        await _readyCompleter!.future.timeout(
          timeout,
          onTimeout: () {
            _markReady();
          },
        );
      } catch (_) {
        _markReady();
      }
    }
  }

  /// Attaches UI event listeners from the active ShopifyWebViewScreen widget.
  void attachListeners({
    ValueChanged<int>? onProgress,
    ValueChanged<String>? onStarted,
    ValueChanged<String>? onFinished,
    ValueChanged<UrlChange>? onUrlChange,
    void Function(bool hasError, String message)? onError,
  }) {
    onProgressChanged = onProgress;
    onPageStarted = onStarted;
    onPageFinished = onFinished;
    onUrlChanged = onUrlChange;
    onErrorChanged = onError;
  }

  /// Detaches UI event listeners when ShopifyWebViewScreen is unmounted.
  void detachListeners() {
    onProgressChanged = null;
    onPageStarted = null;
    onPageFinished = null;
    onUrlChanged = null;
    onErrorChanged = null;
  }

  /// Re-triggers loading if user taps retry on error.
  void reload() {
    _isPreloading = false;
    _isReady = false;
    _hasError = false;
    _errorMessage = '';
    preload();
  }

  /// Disposes controller and timers if needed.
  void dispose() {
    _safetyTimeoutTimer?.cancel();
    detachListeners();
    _controller = null;
    _isPreloading = false;
    _isReady = false;
  }
}
