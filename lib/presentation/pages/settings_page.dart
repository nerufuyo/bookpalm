import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../core/localization/localization_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.instance.translate('settings.title')),
        elevation: 0,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildConnectionStatus(controller),
            const SizedBox(height: 24),
            _buildLanguageSection(controller),
            const SizedBox(height: 24),
            _buildCacheSection(controller),
            const SizedBox(height: 24),
            _buildOfflineSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationService.instance.translate(
                'settings.connectionStatus',
              ),
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  controller.isConnected ? Icons.wifi : Icons.wifi_off,
                  color: controller.isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.isConnected
                      ? LocalizationService.instance.translate(
                          'settings.connected',
                        )
                      : LocalizationService.instance.translate(
                          'settings.offline',
                        ),
                  style: TextStyle(
                    color: controller.isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (!controller.isConnected)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  LocalizationService.instance.translate(
                    'settings.offlineMessage',
                  ),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheSection(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationService.instance.translate(
                'settings.cacheManagement',
              ),
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (controller.isLoadingCacheStats)
              const Center(child: CircularProgressIndicator())
            else ...[
              _buildCacheStatRow(
                LocalizationService.instance.translate('settings.cachedBooks'),
                '${controller.cacheStats['cached_books'] ?? 0}',
                Icons.book,
              ),
              const SizedBox(height: 8),
              _buildCacheStatRow(
                LocalizationService.instance.translate(
                  'settings.cachedSearches',
                ),
                '${controller.cacheStats['cached_lists'] ?? 0}',
                Icons.search,
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isLoadingCacheStats
                    ? null
                    : controller.refreshCacheStats,
                icon: const Icon(Icons.refresh),
                label: Text(
                  LocalizationService.instance.translate(
                    'settings.refreshCacheStats',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isLoadingCacheStats
                    ? null
                    : controller.clearCache,
                icon: const Icon(Icons.clear_all),
                label: Text(
                  LocalizationService.instance.translate(
                    'settings.clearAllCache',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOfflineSection(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationService.instance.translate(
                'settings.offlineFeatures',
              ),
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocalizationService.instance.translate(
                'settings.offlineFeaturesDescription',
              ),
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(
              LocalizationService.instance.translate(
                'settings.browseCachedBooks',
              ),
            ),
            _buildFeatureItem(
              LocalizationService.instance.translate(
                'settings.accessBookmarks',
              ),
            ),
            _buildFeatureItem(
              LocalizationService.instance.translate(
                'settings.viewCachedSearches',
              ),
            ),
            _buildFeatureItem(
              LocalizationService.instance.translate(
                'settings.readBookDetails',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocalizationService.instance.translate('settings.newContentNote'),
              style: Get.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(SettingsController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationService.instance.translate('settings.language'),
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocalizationService.instance.translate(
                'settings.languageDescription',
              ),
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.currentLanguage,
                  isExpanded: true,
                  items: controller.supportedLanguages.entries
                      .map(
                        (entry) => DropdownMenuItem<String>(
                          value: entry.key,
                          child: Row(
                            children: [
                              _getLanguageFlag(entry.key),
                              const SizedBox(width: 12),
                              Text(
                                LocalizationService.instance.translate(
                                  'languages.${entry.key}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null &&
                        newValue != controller.currentLanguage) {
                      controller.changeLanguage(newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLanguageFlag(String languageCode) {
    // Simple emoji flags for each language
    final flags = {
      'en': '🇺🇸',
      'id': '🇮🇩',
      'de': '🇩🇪',
      'ja': '🇯🇵',
      'zh': '🇨🇳',
      'ko': '🇰🇷',
    };

    return Text(
      flags[languageCode] ?? '🌐',
      style: const TextStyle(fontSize: 20),
    );
  }
}
