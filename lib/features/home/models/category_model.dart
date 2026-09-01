import 'package:flutter/material.dart';

/// Category Model for ILAVIYA luxury collections.
@immutable
class HomeCategory {
  final String id;
  final String nameKey;
  final String defaultName;
  final IconData icon;
  final String imageUrl;

  const HomeCategory({
    required this.id,
    required this.nameKey,
    required this.defaultName,
    required this.icon,
    required this.imageUrl,
  });

  static const List<HomeCategory> categories = [
    HomeCategory(
      id: 'all',
      nameKey: 'all',
      defaultName: 'All',
      icon: Icons.grid_view_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=300&q=80',
    ),
    HomeCategory(
      id: 'sarees',
      nameKey: 'sarees',
      defaultName: 'Sarees',
      icon: Icons.checkroom_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=300&q=80',
    ),
    HomeCategory(
      id: 'lehengas',
      nameKey: 'lehengas',
      defaultName: 'Lehengas',
      icon: Icons.style_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=300&q=80',
    ),
    HomeCategory(
      id: 'anarkali',
      nameKey: 'anarkali',
      defaultName: 'Anarkali',
      icon: Icons.woman_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=300&q=80',
    ),
    HomeCategory(
      id: 'kurtis',
      nameKey: 'kurtis',
      defaultName: 'Kurtis',
      icon: Icons.dry_cleaning_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1596783049596-f6d33f7c1348?w=300&q=80',
    ),
    HomeCategory(
      id: 'jewellery',
      nameKey: 'jewellery',
      defaultName: 'Jewellery',
      icon: Icons.diamond_rounded,
      imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=300&q=80',
    ),
  ];
}
