import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/home/models/product_model.dart';

/// Luxury Product Card Widget for ILAVIYA Store.
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleWishlist;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.onToggleWishlist,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isWishlisted = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFECEFF4),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image & Badges
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      p.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFF3F5F8),
                        child: const Center(
                          child: Icon(Icons.photo_outlined, color: Colors.grey, size: 36),
                        ),
                      ),
                    ),
                  ),

                  // Top Left Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        p.badge,
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: SplashTheme.goldLight,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  // Top Right Wishlist Toggle
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isWishlisted = !_isWishlisted;
                        });
                        widget.onToggleWishlist?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 16,
                          color: _isWishlisted ? const Color(0xFFD32F2F) : const Color(0xFF444444),
                        ),
                      ),
                    ),
                  ),

                  // Rating Pill (Bottom Left of Image)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFA000)),
                          const SizedBox(width: 2),
                          Text(
                            '${p.rating}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111111),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Subtitle
                  Text(
                    p.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: SplashTheme.goldDark,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Product Title
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF141720),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Price Row & Quick Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '₹${p.price.toInt()}',
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF11141A),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '₹${p.originalPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8E95A5),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${p.discountPercentage}% OFF',
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),

                      // Quick Add to Bag Button
                      GestureDetector(
                        onTap: widget.onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            gradient: SplashTheme.goldGradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: SplashTheme.goldPrimary.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 16,
                            color: Color(0xFF111111),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
