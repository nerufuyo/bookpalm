import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/localization/localization_service.dart';

class EmptyBookmarksWidget extends StatelessWidget {
  final VoidCallback? onBrowseBooksPressed;

  const EmptyBookmarksWidget({super.key, this.onBrowseBooksPressed});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationService>(
      init: LocalizationService.instance,
      builder: (localization) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.amber.shade100, Colors.amber.shade50],
                  ),
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  size: 60,
                  color: Colors.amber.shade400,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                LocalizationService.instance.translate(
                  'widgets.emptyBookmarks.title',
                ),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  LocalizationService.instance.translate(
                    'widgets.emptyBookmarks.description',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Action Button
              if (onBrowseBooksPressed != null)
                ElevatedButton.icon(
                  onPressed: onBrowseBooksPressed,
                  icon: const Icon(Icons.explore_rounded),
                  label: Text(
                    LocalizationService.instance.translate(
                      'widgets.emptyBookmarks.browseBooks',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
