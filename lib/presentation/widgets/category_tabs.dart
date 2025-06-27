import 'package:flutter/material.dart';

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
    return Container(
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
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category);
                }
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[200],
              checkmarkColor: Colors.white,
              elevation: isSelected ? 2 : 0,
              pressElevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'popular':
        return 'Popular';
      case 'fiction':
        return 'Fiction';
      case 'history':
        return 'History';
      case 'science':
        return 'Science';
      case 'philosophy':
        return 'Philosophy';
      case 'children':
        return 'Children';
      default:
        return category.substring(0, 1).toUpperCase() + category.substring(1);
    }
  }
}
