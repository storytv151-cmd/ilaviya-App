import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/core/constants/splash_constants.dart';
import 'package:my_flutter_app/features/reels/models/reel_model.dart';

/// Service responsible for fetching reels from the backend API.
class ReelsApiService {
  final http.Client _client;
  final String _baseUrl;

  ReelsApiService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? SplashConstants.resolvedModelingReelsApiUrl;

  /// Fetches paginated reels from the server.
  ///
  /// Returns [ReelsApiResponse] on success, or `null` on failure.
  Future<ReelsApiResponse?> fetchReels({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      debugPrint('[ReelsApiService] GET $uri');

      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final apiResponse = ReelsApiResponse.fromJson(jsonBody);

        if (apiResponse.success) {
          debugPrint(
            '[ReelsApiService] Fetched ${apiResponse.data.length} reels (page $page/${apiResponse.pagination.totalPages})',
          );
          return apiResponse;
        } else {
          debugPrint('[ReelsApiService] API returned success: false, message: ${apiResponse.message}');
          return null;
        }
      } else {
        debugPrint('[ReelsApiService] Non-200 HTTP status code: ${response.statusCode}');
        return null;
      }
    } on TimeoutException {
      debugPrint('[ReelsApiService] Request timed out for page $page');
      return null;
    } on SocketException catch (e) {
      debugPrint('[ReelsApiService] Socket/Network error: $e');
      return null;
    } on http.ClientException catch (e) {
      debugPrint('[ReelsApiService] Client error: $e');
      return null;
    } on FormatException catch (e) {
      debugPrint('[ReelsApiService] JSON parse error: $e');
      return null;
    } catch (e, stackTrace) {
      debugPrint('[ReelsApiService] Unexpected error: $e\n$stackTrace');
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
