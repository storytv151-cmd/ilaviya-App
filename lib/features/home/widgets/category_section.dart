import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/splash_theme.dart';
import 'package:my_flutter_app/features/home/models/category_model.dart';

/// Category Navigation Section with circular luxury avatars.
class CategorySection extends StatelessWidget {
  final String selectedCategoryId;
  final Function(String categoryId) onSelectCategory;

  const CategorySection({
    super.key,
    required this.selectedCategoryId,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: HomeCategory.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final cat = HomeCategory.categories[index];
          final isSelected = selectedCategoryId == cat.id;

          return GestureDetector(
            onTap: () => onSelectCategory(cat.id),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular Category Avatar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? SplashTheme.goldSelectedBg : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? SplashTheme.goldPrimary
                          : const Color(0xFFE5E8EE),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? SplashTheme.goldPrimary.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: isSelected ? 10 : 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      cat.icon,
                      size: 24,
                      color: isSelected
                          ? SplashTheme.goldDark
                          : const Color(0xFF4A5060),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Category Title
                Text(
                  cat.defaultName,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? SplashTheme.goldDark
                        : const Color(0xFF333845),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
