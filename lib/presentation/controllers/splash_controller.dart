import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../core/logging/app_logger.dart';

/// Controls splash screen flow and app initialization
class SplashController extends GetxController {
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  /// Initialize app and navigate to home
  Future<void> _initializeApp() async {
    AppLogger.instance.info('Splash screen initialized');

    // Simulate loading time for smooth UX
    await Future.delayed(const Duration(seconds: 2));

    // Debug: Check if context is available
    AppLogger.instance.info('Context available: ${_context != null}');
    AppLogger.instance.info('Get.context available: ${Get.context != null}');

    try {
      // Try using the stored context first
      if (_context != null && _context!.mounted) {
        AppLogger.instance.info('Attempting navigation with stored context...');
        GoRouter.of(_context!).go('/');
        AppLogger.instance.info(
          'Navigation to home completed with stored context',
        );
        return;
      }

      // Fallback to Get.context
      if (Get.context != null) {
        AppLogger.instance.info('Attempting navigation with Get.context...');
        GoRouter.of(Get.context!).go('/');
        AppLogger.instance.info(
          'Navigation to home completed with Get.context',
        );
        return;
      }

      AppLogger.instance.error('No valid context available for navigation');
    } catch (e, stackTrace) {
      AppLogger.instance.error('Navigation error: $e');
      AppLogger.instance.error('Stack trace: $stackTrace');
    }
  }
}
