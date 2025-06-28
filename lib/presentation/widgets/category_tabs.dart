import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/localization_service.dart';

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationService>(
      init: LocalizationService.instance,
      builder: (localization) => Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  _getCategoryDisplayName(category),
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.grey700,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onCategorySelected(category);
                  }
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.accentWithOpacity(0.1),
                checkmarkColor: AppColors.white,
                elevation: isSelected ? 2 : 0,
                pressElevation: 4,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.accent,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    return LocalizationService.instance.translate('categories.$category');
  }
}
