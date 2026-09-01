import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/reels/models/reel_model.dart';
import 'package:my_flutter_app/features/reels/services/reels_api_service.dart';
import 'package:my_flutter_app/features/reels/widgets/reel_video_item.dart';

/// Fashion Modeling Reels Feed Screen connected to live backend API.
class FashionReelsScreen extends StatefulWidget {
  final bool isActive;

  const FashionReelsScreen({
    super.key,
    this.isActive = true,
  });

  @override
  State<FashionReelsScreen> createState() => _FashionReelsScreenState();
}

class _FashionReelsScreenState extends State<FashionReelsScreen> {
  final PageController _pageController = PageController();
  final ReelsApiService _apiService = ReelsApiService();

  List<ReelModel> _reels = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String _errorMessage = '';

  int _currentPage = 1;
  bool _hasMore = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialReels();
  }

  @override
  void didUpdateWidget(covariant FashionReelsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _apiService.dispose();
    super.dispose();
  }

  /// Loads the first page of reels from API.
  Future<void> _loadInitialReels() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _currentPage = 1;
    });

    final response = await _apiService.fetchReels(page: 1, limit: 20);

    if (!mounted) return;

    if (response != null && response.data.isNotEmpty) {
      setState(() {
        _reels = response.data;
        _currentPage = response.pagination.page;
        _hasMore = response.pagination.hasMore;
        _isLoading = false;
        _hasError = false;
      });
    } else {
      // Fallback gracefully to sample reels if API unavailable
      setState(() {
        _reels = ReelModel.sampleReels;
        _isLoading = false;
        _hasError = response == null && ReelModel.sampleReels.isEmpty;
        _hasMore = false;
      });
    }
  }

  /// Loads the next page for seamless infinite scrolling.
  Future<void> _loadMoreReels() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;
    final response = await _apiService.fetchReels(page: nextPage, limit: 20);

    if (!mounted) return;

    if (response != null && response.data.isNotEmpty) {
      setState(() {
        _reels.addAll(response.data);
        _currentPage = response.pagination.page;
        _hasMore = response.pagination.hasMore;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _isLoadingMore = false;
        _hasMore = false;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Auto-fetch next page when reaching near end of current list
    if (index >= _reels.length - 2 && _hasMore && !_isLoadingMore) {
      _loadMoreReels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Main Feed View
          if (_isLoading)
            _buildLoadingState()
          else if (_hasError && _reels.isEmpty)
            _buildErrorState()
          else
            RefreshIndicator(
              color: SplashTheme.goldPrimary,
              backgroundColor: const Color(0xFF141824),
              onRefresh: _loadInitialReels,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _reels.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final reel = _reels[index];
                  return ReelVideoItem(
                    key: ValueKey(reel.id),
                    reel: reel,
                    isCurrent: widget.isActive && _currentIndex == index,
                  );
                },
              ),
            ),

          // 2. Top Header Overlay (ILAVIYA LIVE REELS)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'ILAVIYA',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: SplashTheme.goldPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE REELS',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111111),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Refresh Feed',
                        icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                        onPressed: _loadInitialReels,
                      ),
                      IconButton(
                        tooltip: 'Camera',
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Loading More Indicator at bottom if scrolling near end
          if (_isLoadingMore)
            const Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: SplashTheme.goldPrimary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: const Color(0xFF0D0F17),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: SplashTheme.goldPrimary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const CircularProgressIndicator(
                color: SplashTheme.goldPrimary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ILAVIYA COUTURE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Loading trending fashion reels...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: const Color(0xFF0D0F17),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 54,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load reels',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'Please check your internet connection or try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SplashTheme.goldPrimary,
                foregroundColor: const Color(0xFF111111),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _loadInitialReels,
              child: const Text(
                'RETRY',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
