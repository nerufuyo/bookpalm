import 'package:flutter/material.dart';
import '../../core/localization/localization_service.dart';
import '../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  final HomeController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> availableLanguages = [
    'en',
    'fr',
    'de',
    'es',
    'it',
    'pt',
    'ru',
    'zh',
    'ja',
    'ar',
  ];

  final List<String> availableSortOptions = [
    'popular',
    'ascending',
    'descending',
  ];

  List<String> selectedLanguages = [];
  String selectedSort = 'popular';
  int? authorYearStart;
  int? authorYearEnd;

  @override
  void initState() {
    super.initState();
    // Initialize with current filter values
    selectedLanguages = widget.controller.selectedLanguages.toList();
    selectedSort = widget.controller.selectedSort.value;
    authorYearStart = widget.controller.authorYearStart.value;
    authorYearEnd = widget.controller.authorYearEnd.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationService.instance.translate(
                  'widgets.filterBottomSheet.title',
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedLanguages.clear();
                    selectedSort = 'popular';
                    authorYearStart = null;
                    authorYearEnd = null;
                  });
                },
                child: Text(
                  LocalizationService.instance.translate(
                    'widgets.filterBottomSheet.clearAll',
                  ),
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Languages Filter
          Text(
            LocalizationService.instance.translate(
              'widgets.filterBottomSheet.languages',
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableLanguages.map((language) {
              final isSelected = selectedLanguages.contains(language);
              return FilterChip(
                label: Text(
                  _getLanguageDisplayName(language),
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.grey700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedLanguages.add(language);
                    } else {
                      selectedLanguages.remove(language);
                    }
                  });
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.accentWithOpacity(0.1),
                checkmarkColor: AppColors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.accent,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Sort Filter
          Text(
            LocalizationService.instance.translate(
              'widgets.filterBottomSheet.sortBy',
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 12),
          ...availableSortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(
                _getSortDisplayName(option),
                style: TextStyle(
                  color: AppColors.grey800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: option,
              groupValue: selectedSort,
              onChanged: (value) {
                setState(() {
                  selectedSort = value!;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
            );
          }),

          const SizedBox(height: 24),

          // Author Birth Year Filter
          Text(
            LocalizationService.instance.translate(
              'widgets.filterBottomSheet.authorYearRange',
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: LocalizationService.instance.translate(
                      'widgets.filterBottomSheet.fromYear',
                    ),
                    labelStyle: TextStyle(color: AppColors.grey600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.grey300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.grey50,
                  ),
                  style: TextStyle(color: AppColors.grey800),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    authorYearStart = int.tryParse(value);
                  },
                  controller: TextEditingController(
                    text: authorYearStart?.toString() ?? '',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: LocalizationService.instance.translate(
                      'widgets.filterBottomSheet.toYear',
                    ),
                    labelStyle: TextStyle(color: AppColors.grey600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.grey300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.grey50,
                  ),
                  style: TextStyle(color: AppColors.grey800),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    authorYearEnd = int.tryParse(value);
                  },
                  controller: TextEditingController(
                    text: authorYearEnd?.toString() ?? '',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.controller.applyFilters(
                  languages: selectedLanguages,
                  sort: selectedSort,
                  authorYearStart: authorYearStart,
                  authorYearEnd: authorYearEnd,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: AppColors.primaryWithOpacity(0.3),
              ),
              child: Text(
                LocalizationService.instance.translate(
                  'widgets.filterBottomSheet.applyFilters',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _getLanguageDisplayName(String language) {
    return LocalizationService.instance.translate(
      'widgets.filterBottomSheet.languageNames.$language',
    );
  }

  String _getSortDisplayName(String sort) {
    return LocalizationService.instance.translate(
      'widgets.filterBottomSheet.sortOptions.$sort',
    );
  }
}
