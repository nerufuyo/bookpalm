import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildConnectionStatus(controller),
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
              'Connection Status',
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
                  controller.isConnected ? 'Connected to Internet' : 'Offline',
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
                  'You can still browse cached books and bookmarks while offline.',
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
              'Cache Management',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (controller.isLoadingCacheStats)
              const Center(child: CircularProgressIndicator())
            else ...[
              _buildCacheStatRow(
                'Cached Books',
                '${controller.cacheStats['cached_books'] ?? 0}',
                Icons.book,
              ),
              const SizedBox(height: 8),
              _buildCacheStatRow(
                'Cached Searches',
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
                label: const Text('Refresh Cache Stats'),
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
                label: const Text('Clear All Cache'),
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
              'Offline Features',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'BookPalm automatically caches books and search results for offline viewing. When you\'re offline, you can still:',
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Browse previously viewed books'),
            _buildFeatureItem('Access your bookmarks'),
            _buildFeatureItem('View cached search results'),
            _buildFeatureItem('Read book details'),
            const SizedBox(height: 8),
            Text(
              'Note: New content requires an internet connection.',
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
}
