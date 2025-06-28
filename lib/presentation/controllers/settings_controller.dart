import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/connection_service.dart';
import '../../../core/localization/localization_service.dart';
import '../../../core/injection/injection_container.dart' as di;
import '../../../data/datasources/book_local_data_source.dart';

class SettingsController extends GetxController {
  final ConnectionService _connectionService = Get.find<ConnectionService>();
  final LocalizationService _localizationService = LocalizationService.instance;
  final BookLocalDataSource _localDataSource = di.sl<BookLocalDataSource>();

  final RxBool _isLoadingCacheStats = false.obs;
  final RxMap<String, int> _cacheStats = <String, int>{}.obs;

  bool get isConnected => _connectionService.isConnected;
  bool get isLoadingCacheStats => _isLoadingCacheStats.value;
  Map<String, int> get cacheStats => _cacheStats;
  String get currentLanguage => _localizationService.currentLanguage;
  Map<String, String> get supportedLanguages =>
      _localizationService.supportedLanguages;

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
          message: LocalizationService.instance.translate(
            'snackbars.cacheStatsLoadFailed',
            {'error': e.toString()},
          ),
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
          title: Text(
            LocalizationService.instance.translate('dialogs.clearCache.title'),
          ),
          content: Text(
            LocalizationService.instance.translate(
              'dialogs.clearCache.content',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(
                LocalizationService.instance.translate(
                  'dialogs.clearCache.cancel',
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text(
                LocalizationService.instance.translate(
                  'dialogs.clearCache.confirm',
                ),
              ),
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
            message: LocalizationService.instance.translate(
              'snackbars.cacheClearSuccess',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: LocalizationService.instance.translate(
            'snackbars.cacheClearFailed',
            {'error': e.toString()},
          ),
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
          message: LocalizationService.instance.translate(
            'snackbars.oldCacheClearSuccess',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: LocalizationService.instance.translate(
            'snackbars.oldCacheClearFailed',
            {'error': e.toString()},
          ),
          backgroundColor: Get.theme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      await _localizationService.changeLanguage(languageCode);
      Get.showSnackbar(
        GetSnackBar(
          message: LocalizationService.instance.translate(
            'snackbars.languageChangeSuccess',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      // Force rebuild of the settings page
      update();
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: LocalizationService.instance.translate(
            'snackbars.languageChangeFailed',
            {'error': e.toString()},
          ),
          backgroundColor: Get.theme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
