import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/home/services/shopify_webview_preloader.dart';

void main() {
  group('ShopifyWebViewPreloader Tests', () {
    test('Singleton instance exists and initializes with default state', () {
      final preloader = ShopifyWebViewPreloader.instance;
      expect(preloader, isNotNull);
    });

    test('waitUntilReady completes safely even on timeout or error', () async {
      final preloader = ShopifyWebViewPreloader.instance;
      // Preload with fallback/error in test environment without platform view
      preloader.preload();

      // waitUntilReady should complete within timeout and not hang
      final future = preloader.waitUntilReady(
        timeout: const Duration(milliseconds: 200),
      );

      await expectLater(future, completes);
    });

    test('attachListeners and detachListeners manage callbacks cleanly', () {
      final preloader = ShopifyWebViewPreloader.instance;

      int progressVal = 0;
      preloader.attachListeners(
        onProgress: (p) => progressVal = p,
      );

      preloader.onProgressChanged?.call(85);
      expect(progressVal, 85);

      preloader.detachListeners();
      expect(preloader.onProgressChanged, isNull);
      expect(preloader.onPageStarted, isNull);
      expect(preloader.onPageFinished, isNull);
    });
  });
}
