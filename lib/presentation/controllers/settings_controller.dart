import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/connection_service.dart';
import '../../../core/injection/injection_container.dart' as di;
import '../../../data/datasources/book_local_data_source.dart';

class SettingsController extends GetxController {
  final ConnectionService _connectionService = Get.find<ConnectionService>();
  final BookLocalDataSource _localDataSource = di.sl<BookLocalDataSource>();

  final RxBool _isLoadingCacheStats = false.obs;
  final RxMap<String, int> _cacheStats = <String, int>{}.obs;

  bool get isConnected => _connectionService.isConnected;
  bool get isLoadingCacheStats => _isLoadingCacheStats.value;
  Map<String, int> get cacheStats => _cacheStats;

  @override
  void onInit() {
    super.onInit();
    refreshCacheStats();
  }

  Future<void> refreshCacheStats() async {
    try {
      _isLoadingCacheStats.value = true;
      final stats = await _localDataSource.getCacheStats();
      _cacheStats.assignAll(stats);
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Failed to load cache stats: $e',
          backgroundColor: Get.theme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      _isLoadingCacheStats.value = false;
    }
  }

  Future<void> clearCache() async {
    try {
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will remove all cached books and search results. '
            'You will need an internet connection to browse books again. '
            'Your bookmarks will not be affected.\n\n'
            'Are you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Clear Cache'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        _isLoadingCacheStats.value = true;
        await _localDataSource.clearAllCache();
        await refreshCacheStats();

        Get.showSnackbar(
          GetSnackBar(
            message: 'Cache cleared successfully',
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Failed to clear cache: $e',
          backgroundColor: Get.theme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      _isLoadingCacheStats.value = false;
    }
  }

  Future<void> clearOldCache() async {
    try {
      await _localDataSource.clearOldCache();
      await refreshCacheStats();

      Get.showSnackbar(
        GetSnackBar(
          message: 'Old cache cleared successfully',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Failed to clear old cache: $e',
          backgroundColor: Get.theme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
