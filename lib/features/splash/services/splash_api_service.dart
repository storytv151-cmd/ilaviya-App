import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/features/splash/models/splash_model.dart';

/// Service responsible for fetching dynamic splash configuration from the API.
class SplashApiService {
  final http.Client _client;
  final String _endpoint;

  SplashApiService({
    http.Client? client,
    String? endpoint,
  })  : _client = client ?? http.Client(),
        _endpoint = endpoint ?? SplashConstants.defaultApiUrl;

  /// Fetches splash data from the backend API.
  /// 
  /// Returns [SplashData] if valid dynamic splash configuration exists.
  /// Returns `null` if data is null, or on any error (timeout, network down, 500, malformed JSON).
  /// This method is guaranteed to never throw an uncaught exception.
  Future<SplashData?> fetchSplashData() async {
    try {
      final uri = Uri.parse(_endpoint);
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(SplashConstants.apiTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final splashResponse = SplashResponse.fromJson(jsonBody);
        
        if (splashResponse.success && splashResponse.data != null) {
          debugPrint('[SplashApiService] Valid dynamic splash received: ${splashResponse.data}');
          return splashResponse.data;
        } else {
          debugPrint('[SplashApiService] Splash API returned null data or inactive state.');
          return null;
        }
      } else {
        debugPrint('[SplashApiService] Non-200 HTTP status code: ${response.statusCode}');
        return null;
      }
    } on TimeoutException {
      debugPrint('[SplashApiService] Splash API request timed out (${SplashConstants.apiTimeout.inSeconds}s). Falling back to default.');
      return null;
    } on SocketException catch (e) {
      debugPrint('[SplashApiService] Network/Socket error connecting to splash API: $e');
      return null;
    } on http.ClientException catch (e) {
      debugPrint('[SplashApiService] HTTP client error: $e');
      return null;
    } on FormatException catch (e) {
      debugPrint('[SplashApiService] JSON decoding error: $e');
      return null;
    } catch (e, stackTrace) {
      debugPrint('[SplashApiService] Unexpected error during splash fetch: $e\n$stackTrace');
      return null;
    }
  }

  /// Disposes internal resources if created.
  void dispose() {
    _client.close();
  }
}
