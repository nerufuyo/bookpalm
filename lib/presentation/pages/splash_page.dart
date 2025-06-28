import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_colors.dart';

/// App splash screen with logo and loading animation
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    AppLogger.instance.info('Splash screen initialized');

    // Simulate loading time for smooth UX - reduced for testing
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      AppLogger.instance.info('Attempting navigation to home...');
      try {
        context.go('/');
        AppLogger.instance.info('Navigation to home completed');
      } catch (e) {
        AppLogger.instance.error('Navigation error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationService>(
      init: LocalizationService.instance,
      builder: (localization) => Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu_book,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // App Name
              Text(
                localization.translate('splash.appName'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              Text(
                localization.translate('splash.tagline'),
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 48),

              // Loading Indicator
              CircularProgressIndicator(color: AppColors.highlight),
            ],
          ),
        ),
      ),
    );
  }
}
