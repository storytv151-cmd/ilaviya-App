import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/features/splash/models/splash_model.dart';

void main() {
  group('SplashModel Parsing & Clamping Tests', () {
    test('Correctly parses valid image splash payload', () {
      final json = {
        'success': true,
        'data': {
          'type': 'image',
          'mediaUrl': 'https://example.com/splash.jpg',
          'duration': 4,
        }
      };

      final response = SplashResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data, isNotNull);
      expect(response.data!.type, SplashType.image);
      expect(response.data!.mediaUrl, 'https://example.com/splash.jpg');
      expect(response.data!.duration, const Duration(seconds: 4));
    });

    test('Correctly parses valid video splash payload with fallback', () {
      final json = {
        'success': true,
        'data': {
          'type': 'video',
          'mediaUrl': 'https://example.com/splash.mp4',
          'fallbackImageUrl': 'https://example.com/fallback.jpg',
          'duration': 5.5,
        }
      };

      final response = SplashResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data, isNotNull);
      expect(response.data!.type, SplashType.video);
      expect(response.data!.mediaUrl, 'https://example.com/splash.mp4');
      expect(response.data!.fallbackImageUrl, 'https://example.com/fallback.jpg');
      expect(response.data!.duration, const Duration(milliseconds: 5500));
    });

    test('Handles data: null response cleanly', () {
      final json = {
        'success': true,
        'data': null,
      };

      final response = SplashResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data, isNull);
    });

    test('Clamps duration to minimum limit (2s)', () {
      final json = {
        'type': 'image',
        'mediaUrl': 'https://example.com/splash.jpg',
        'duration': 0.5, // Less than min 2s
      };

      final data = SplashData.fromJson(json);

      expect(data.duration, SplashConstants.minSplashDuration);
    });

    test('Clamps duration to maximum limit (8s)', () {
      final json = {
        'type': 'image',
        'mediaUrl': 'https://example.com/splash.jpg',
        'duration': 25.0, // Exceeds max 8s
      };

      final data = SplashData.fromJson(json);

      expect(data.duration, SplashConstants.maxSplashDuration);
    });

    test('Uses default duration when duration field is omitted', () {
      final json = {
        'type': 'image',
        'mediaUrl': 'https://example.com/splash.jpg',
      };

      final data = SplashData.fromJson(json);

      expect(data.duration, SplashConstants.defaultSplashDuration);
    });

    test('Parses string duration safely', () {
      final json = {
        'type': 'image',
        'mediaUrl': 'https://example.com/splash.jpg',
        'duration': '3',
      };

      final data = SplashData.fromJson(json);

      expect(data.duration, const Duration(seconds: 3));
    });

    test('Throws FormatException on missing or invalid type', () {
      expect(
        () => SplashData.fromJson({'type': 'invalid_type', 'mediaUrl': 'http://url'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws FormatException on missing or empty mediaUrl', () {
      expect(
        () => SplashData.fromJson({'type': 'image', 'mediaUrl': ''}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
