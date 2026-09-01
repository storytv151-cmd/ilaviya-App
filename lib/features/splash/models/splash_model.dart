import 'package:flutter/foundation.dart';
import 'package:my_flutter_app/core/constants/splash_constants.dart';

/// Enum representing the dynamic media type for splash.
enum SplashType {
  image,
  video;

  static SplashType? fromString(String? value) {
    if (value == null) return null;
    final normalized = value.trim().toLowerCase();
    if (normalized == 'image' || normalized == 'img') {
      return SplashType.image;
    } else if (normalized == 'video' || normalized == 'mp4') {
      return SplashType.video;
    }
    return null;
  }
}

/// Data model representing the dynamic splash media configuration.
@immutable
class SplashData {
  final SplashType type;
  final String mediaUrl;
  final String? fallbackImageUrl;
  final Duration duration;

  const SplashData({
    required this.type,
    required this.mediaUrl,
    this.fallbackImageUrl,
    required this.duration,
  });

  /// Factory constructor to safely parse SplashData from JSON.
  /// Enforces URL validation, type checking, and duration clamping.
  factory SplashData.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString();
    final type = SplashType.fromString(rawType);
    if (type == null) {
      throw const FormatException('Invalid or missing splash media type');
    }

    final rawMediaUrl = json['mediaUrl']?.toString().trim();
    if (rawMediaUrl == null || rawMediaUrl.isEmpty) {
      throw const FormatException('Missing or empty mediaUrl');
    }

    final rawFallbackUrl = json['fallbackImageUrl']?.toString().trim();
    final fallbackImageUrl = (rawFallbackUrl != null && rawFallbackUrl.isNotEmpty)
        ? rawFallbackUrl
        : null;

    // Parse and clamp duration
    Duration parsedDuration = SplashConstants.defaultSplashDuration;
    final rawDuration = json['duration'];
    if (rawDuration != null) {
      double? seconds;
      if (rawDuration is num) {
        seconds = rawDuration.toDouble();
      } else if (rawDuration is String) {
        seconds = double.tryParse(rawDuration);
      }

      if (seconds != null && seconds > 0) {
        // Enforce sensible minimum and maximum duration boundaries
        final clampedSeconds = seconds.clamp(
          SplashConstants.minSplashDuration.inSeconds.toDouble(),
          SplashConstants.maxSplashDuration.inSeconds.toDouble(),
        );
        parsedDuration = Duration(milliseconds: (clampedSeconds * 1000).round());
      }
    }

    return SplashData(
      type: type,
      mediaUrl: rawMediaUrl,
      fallbackImageUrl: fallbackImageUrl,
      duration: parsedDuration,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'mediaUrl': mediaUrl,
        if (fallbackImageUrl != null) 'fallbackImageUrl': fallbackImageUrl,
        'duration': duration.inMilliseconds / 1000.0,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplashData &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          mediaUrl == other.mediaUrl &&
          fallbackImageUrl == other.fallbackImageUrl &&
          duration == other.duration;

  @override
  int get hashCode => Object.hash(type, mediaUrl, fallbackImageUrl, duration);

  @override
  String toString() =>
      'SplashData(type: ${type.name}, mediaUrl: $mediaUrl, fallback: $fallbackImageUrl, duration: ${duration.inSeconds}s)';
}

/// Response container for the splash endpoint.
@immutable
class SplashResponse {
  final bool success;
  final SplashData? data;
  final String? message;

  const SplashResponse({
    required this.success,
    this.data,
    this.message,
  });

  /// Factory constructor to parse top-level API response.
  /// Handles `{ "success": true, "data": null }` or `{ "success": false }` cleanly.
  factory SplashResponse.fromJson(Map<String, dynamic> json) {
    final success = json['success'] == true;
    final rawData = json['data'];

    SplashData? data;
    if (success && rawData is Map<String, dynamic>) {
      try {
        data = SplashData.fromJson(rawData);
      } catch (e) {
        // If data parsing fails, keep data as null so caller falls back to local splash.
        data = null;
      }
    }

    return SplashResponse(
      success: success,
      data: data,
      message: json['message']?.toString(),
    );
  }
}
