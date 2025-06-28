import 'package:flutter/material.dart';
import '../../core/localization/localization_service.dart';
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Languages Filter
          const Text(
            'Languages',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    color: isSelected ? Colors.white : Colors.grey[700],
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
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[200],
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Sort Filter
          const Text(
            'Sort by',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...availableSortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(_getSortDisplayName(option)),
              value: option,
              groupValue: selectedSort,
              onChanged: (value) {
                setState(() {
                  selectedSort = value!;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            );
          }),

          const SizedBox(height: 24),

          // Author Birth Year Filter
          const Text(
            'Author Birth Year Range',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'From Year',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
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
                  decoration: const InputDecoration(
                    labelText: 'To Year',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
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
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    switch (language) {
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'es':
        return 'Spanish';
      case 'it':
        return 'Italian';
      case 'pt':
        return 'Portuguese';
      case 'ru':
        return 'Russian';
      case 'zh':
        return 'Chinese';
      case 'ja':
        return 'Japanese';
      case 'ar':
        return 'Arabic';
      default:
        return language.toUpperCase();
    }
  }

  String _getSortDisplayName(String sort) {
    switch (sort) {
      case 'popular':
        return 'Most Popular';
      case 'ascending':
        return 'ID Ascending';
      case 'descending':
        return 'ID Descending';
      default:
        return sort;
    }
  }
}
