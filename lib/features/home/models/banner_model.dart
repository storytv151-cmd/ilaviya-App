import 'package:flutter/material.dart';

/// Hero Banner item model for ILAVIYA home carousel.
@immutable
class HomeBanner {
  final String id;
  final String tag;
  final String title;
  final String subtitle;
  final String ctaText;
  final String imageUrl;
  final Color badgeColor;

  const HomeBanner({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.imageUrl,
    this.badgeColor = const Color(0xFFC79825),
  });

  static const List<HomeBanner> banners = [
    HomeBanner(
      id: 'b1',
      tag: 'HERITAGE SILK 2026',
      title: 'The Royal Banarasi Edit',
      subtitle: 'Pure Handwoven Zari Silk Sarees • Up to 40% Off',
      ctaText: 'EXPLORE COLLECTION',
      imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=900&auto=format&fit=crop&q=80',
    ),
    HomeBanner(
      id: 'b2',
      tag: 'BRIDAL MASTERPIECES',
      title: 'Grand Couture Lehengas',
      subtitle: 'Intricate Handcrafted Embroidery for the Royal Bride',
      ctaText: 'DISCOVER BRIDAL',
      imageUrl: 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=900&auto=format&fit=crop&q=80',
    ),
    HomeBanner(
      id: 'b3',
      tag: 'NEW ARRIVALS',
      title: 'Designer Anarkalis & Gowns',
      subtitle: 'Contemporary Silhouettes with Traditional Grandeur',
      ctaText: 'SHOP NEW IN',
      imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=900&auto=format&fit=crop&q=80',
    ),
  ];
}
