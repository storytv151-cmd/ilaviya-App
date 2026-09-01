import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_flutter_app/features/splash/models/splash_model.dart';
import 'package:my_flutter_app/features/splash/services/splash_api_service.dart';

void main() {
  group('SplashApiService Tests', () {
    test('Returns SplashData when API responds with active image splash', () async {
      final mockClient = MockClient((request) async {
        final body = jsonEncode({
          'success': true,
          'data': {
            'type': 'image',
            'mediaUrl': 'https://cdn.example.com/banner.jpg',
            'duration': 4,
          }
        });
        return http.Response(body, 200, headers: {'content-type': 'application/json'});
      });

      final service = SplashApiService(client: mockClient);
      final result = await service.fetchSplashData();

      expect(result, isNotNull);
      expect(result!.type, SplashType.image);
      expect(result.mediaUrl, 'https://cdn.example.com/banner.jpg');
      expect(result.duration, const Duration(seconds: 4));
    });

    test('Returns SplashData when API responds with active video splash', () async {
      final mockClient = MockClient((request) async {
        final body = jsonEncode({
          'success': true,
          'data': {
            'type': 'video',
            'mediaUrl': 'https://cdn.example.com/video.mp4',
            'fallbackImageUrl': 'https://cdn.example.com/fallback.jpg',
            'duration': 5,
          }
        });
        return http.Response(body, 200, headers: {'content-type': 'application/json'});
      });

      final service = SplashApiService(client: mockClient);
      final result = await service.fetchSplashData();

      expect(result, isNotNull);
      expect(result!.type, SplashType.video);
      expect(result.mediaUrl, 'https://cdn.example.com/video.mp4');
      expect(result.fallbackImageUrl, 'https://cdn.example.com/fallback.jpg');
    });

    test('Returns null when API returns { success: true, data: null }', () async {
      final mockClient = MockClient((request) async {
        final body = jsonEncode({
          'success': true,
          'data': null,
        });
        return http.Response(body, 200, headers: {'content-type': 'application/json'});
      });

      final service = SplashApiService(client: mockClient);
      final result = await service.fetchSplashData();

      expect(result, isNull);
    });

    test('Returns null gracefully on HTTP 500 server error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = SplashApiService(client: mockClient);
      final result = await service.fetchSplashData();

      expect(result, isNull);
    });

    test('Returns null gracefully on malformed JSON payload', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid { JSON payload', 200);
      });

      final service = SplashApiService(client: mockClient);
      final result = await service.fetchSplashData();

      expect(result, isNull);
    });

    test('Returns null gracefully on client exception / network failure', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Connection reset by peer');
      });

      final service = SplashApiService(client: mockClient);
      final result = await service.fetchSplashData();

      expect(result, isNull);
    });
  });
}
