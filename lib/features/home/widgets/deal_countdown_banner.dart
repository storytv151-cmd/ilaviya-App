import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';

/// Luxury Flash Deal Countdown Banner.
class DealCountdownBanner extends StatefulWidget {
  const DealCountdownBanner({super.key});

  @override
  State<DealCountdownBanner> createState() => _DealCountdownBannerState();
}

class _DealCountdownBannerState extends State<DealCountdownBanner> {
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = const Duration(hours: 6, minutes: 42, seconds: 18);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = _remainingTime.inHours;
    final minutes = _remainingTime.inMinutes.remainder(60);
    final seconds = _remainingTime.inSeconds.remainder(60);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11141A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Offer Tag
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: SplashTheme.goldPrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FLASH SALE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111111),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ENDS IN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9EA5B5),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Royal Silk & Bridal Edit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Use code ROYAL20 for Extra 20% Off',
                  style: TextStyle(
                    fontSize: 11,
                    color: SplashTheme.goldLight,
                  ),
                ),
              ],
            ),
          ),

          // Right Countdown Timer Badges
          Row(
            children: [
              _buildTimerBox(_formatTime(hours), 'HRS'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text(':', style: TextStyle(color: SplashTheme.goldPrimary, fontWeight: FontWeight.bold)),
              ),
              _buildTimerBox(_formatTime(minutes), 'MIN'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Text(':', style: TextStyle(color: SplashTheme.goldPrimary, fontWeight: FontWeight.bold)),
              ),
              _buildTimerBox(_formatTime(seconds), 'SEC'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBox(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF1E232F),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: SplashTheme.goldPrimary.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8C93A4),
          ),
        ),
      ],
    );
  }
}
