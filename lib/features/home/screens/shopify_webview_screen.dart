import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/home/services/shopify_webview_preloader.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Shopify Storefront WebView Screen with real-time loading bar,
/// offline retry, smooth web navigation, and automatic root-page detection.
class ShopifyWebViewScreen extends StatefulWidget {
  final String initialUrl;
  final ValueChanged<bool>? onRootStateChanged; // true = at root (show bottom bar), false = in subpage (hide bottom bar)

  const ShopifyWebViewScreen({
    super.key,
    this.initialUrl = SplashConstants.shopifyStoreUrl,
    this.onRootStateChanged,
  });

  @override
  State<ShopifyWebViewScreen> createState() => _ShopifyWebViewScreenState();
}

class _ShopifyWebViewScreenState extends State<ShopifyWebViewScreen> {
  WebViewController? _controller;
  int _loadingProgress = 0;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isUsingPreloader = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  @override
  void dispose() {
    if (_isUsingPreloader) {
      ShopifyWebViewPreloader.instance.detachListeners();
    }
    super.dispose();
  }

  void _initWebView() {
    final preloader = ShopifyWebViewPreloader.instance;
    final isRootStore = widget.initialUrl == SplashConstants.shopifyStoreUrl;

    // Use preloaded controller if available for the root store URL
    if (isRootStore && preloader.controller != null) {
      _isUsingPreloader = true;
      _controller = preloader.controller;
      _loadingProgress = preloader.loadingProgress;
      _hasError = preloader.hasError;
      _errorMessage = preloader.errorMessage;

      preloader.attachListeners(
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _loadingProgress = progress;
            });
          }
        },
        onStarted: (url) {
          if (mounted) {
            setState(() {
              _hasError = false;
              _errorMessage = '';
              _loadingProgress = 10;
            });
            _checkNavigationDepth(url);
          }
        },
        onFinished: (url) {
          if (mounted) {
            setState(() {
              _loadingProgress = 100;
            });
            _checkNavigationDepth(url);
          }
        },
        onUrlChange: (change) {
          if (change.url != null) {
            _checkNavigationDepth(change.url!);
          }
        },
        onError: (hasError, message) {
          if (mounted) {
            setState(() {
              _hasError = hasError;
              _errorMessage = message;
            });
          }
        },
      );

      // Check initial URL navigation depth
      _controller?.currentUrl().then((currentUrl) {
        if (mounted && currentUrl != null) {
          _checkNavigationDepth(currentUrl);
        }
      });
      return;
    }

    // Otherwise create dedicated local WebViewController (e.g. for custom product URLs)
    _isUsingPreloader = false;
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _loadingProgress = progress;
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _hasError = false;
                  _loadingProgress = 10;
                });
                _checkNavigationDepth(url);
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _loadingProgress = 100;
                });
                _checkNavigationDepth(url);
              }
            },
            onUrlChange: (UrlChange change) {
              if (change.url != null) {
                _checkNavigationDepth(change.url!);
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted && error.isForMainFrame == true) {
                setState(() {
                  _hasError = true;
                  _errorMessage = error.description;
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.initialUrl));

      _controller = controller;
    } catch (e) {
      if (kDebugMode) {
        print('[ShopifyWebView] Initialization error: $e');
      }
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _onRetry() {
    if (_isUsingPreloader) {
      ShopifyWebViewPreloader.instance.reload();
      _initWebView();
    } else {
      _initWebView();
    }
  }

  bool _isRootUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final homeUri = Uri.parse(SplashConstants.shopifyStoreUrl);
      if (uri.host == homeUri.host) {
        final path = uri.path.trim();
        return path.isEmpty || path == '/' || path == '/index';
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkNavigationDepth(String url) async {
    final canGoBack = await _controller?.canGoBack() ?? false;
    final isRoot = _isRootUrl(url) && !canGoBack;
    widget.onRootStateChanged?.call(isRoot);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final controller = _controller;
        if (controller != null && await controller.canGoBack()) {
          await controller.goBack();
          final currentUrl = await controller.currentUrl();
          if (currentUrl != null) {
            await _checkNavigationDepth(currentUrl);
          }
        } else {
          // If no back history in webview, pop screen
          if (context.mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 1. Main WebView Content
            if (_hasError)
              _buildErrorFallback()
            else if (_controller != null)
              WebViewWidget(controller: _controller!)
            else
              const Center(
                child: CircularProgressIndicator(
                  color: SplashTheme.goldPrimary,
                ),
              ),

            // 2. Sleek Linear Progress Bar (Top)
            if (_loadingProgress > 0 && _loadingProgress < 100 && !_hasError)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _loadingProgress / 100.0,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    SplashTheme.goldPrimary,
                  ),
                  minHeight: 2.5,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Displays when the internet is unavailable or URL fails to load.
  Widget _buildErrorFallback() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: SplashTheme.goldSelectedBg,
                shape: BoxShape.circle,
                border: Border.all(color: SplashTheme.goldPrimary.withValues(alpha: 0.3)),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: SplashTheme.goldDark,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to Connect to Store',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF141720),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'Please check your internet connection and tap retry.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF767E90),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF111111), size: 18),
              label: const Text(
                'RETRY STORE',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontSize: 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: SplashTheme.goldPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
