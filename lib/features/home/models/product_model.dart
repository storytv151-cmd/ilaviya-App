import 'package:flutter/material.dart';

/// Product Model for ILAVIYA luxury e-commerce store.
@immutable
class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewsCount;
  final String badge;
  final String imageUrl;
  final List<Color> availableColors;
  final bool isNew;
  final bool isBestSeller;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.originalPrice,
    this.rating = 4.9,
    this.reviewsCount = 128,
    this.badge = 'EXCLUSIVE',
    required this.imageUrl,
    this.availableColors = const [Color(0xFF800020), Color(0xFFD4AF37), Color(0xFF0F52BA)],
    this.isNew = false,
    this.isBestSeller = false,
  });

  int get discountPercentage =>
      (((originalPrice - price) / originalPrice) * 100).round();

  static const List<Product> sampleProducts = [
    Product(
      id: 'p1',
      title: 'Royal Banarasi Katan Silk Saree',
      category: 'Sarees',
      price: 4999,
      originalPrice: 7999,
      rating: 4.9,
      reviewsCount: 342,
      badge: 'HANDCRAFTED',
      imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=600&auto=format&fit=crop&q=80',
      isBestSeller: true,
    ),
    Product(
      id: 'p2',
      title: 'Heritage Zardozi Embroidered Bridal Lehenga',
      category: 'Lehengas',
      price: 18499,
      originalPrice: 24999,
      rating: 5.0,
      reviewsCount: 189,
      badge: 'BRIDAL EDIT',
      imageUrl: 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=600&auto=format&fit=crop&q=80',
      isNew: true,
    ),
    Product(
      id: 'p3',
      title: 'Chanderi Gold Thread Silk Anarkali Gown',
      category: 'Anarkali',
      price: 3499,
      originalPrice: 5499,
      rating: 4.8,
      reviewsCount: 215,
      badge: 'NEW IN',
      imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=600&auto=format&fit=crop&q=80',
      isNew: true,
    ),
    Product(
      id: 'p4',
      title: 'Pure Organza Floral Handpainted Saree',
      category: 'Sarees',
      price: 3899,
      originalPrice: 5999,
      rating: 4.9,
      reviewsCount: 412,
      badge: 'BESTSELLER',
      imageUrl: 'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=600&auto=format&fit=crop&q=80',
      isBestSeller: true,
    ),
    Product(
      id: 'p5',
      title: 'Kundan & Pearl Heritage Temple Choker Set',
      category: 'Jewellery',
      price: 2499,
      originalPrice: 3999,
      rating: 4.9,
      reviewsCount: 520,
      badge: 'ROYAL JEWELS',
      imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=600&auto=format&fit=crop&q=80',
      isBestSeller: true,
    ),
    Product(
      id: 'p6',
      title: 'Mirror Work Georgette Designer Kurti Set',
      category: 'Kurtis',
      price: 2899,
      originalPrice: 4299,
      rating: 4.7,
      reviewsCount: 98,
      badge: 'TRENDING',
      imageUrl: 'https://images.unsplash.com/photo-1596783049596-f6d33f7c1348?w=600&auto=format&fit=crop&q=80',
      isNew: true,
    ),
  ];
}
