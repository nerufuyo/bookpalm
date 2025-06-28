import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/localization/localization_service.dart';
import 'core/logging/app_logger.dart';
import 'core/services/connection_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.instance.initialize();
  AppLogger.instance.info('Application starting...', tag: 'Main');

  // Initialize localization
  await LocalizationService.instance.loadSavedLanguage();
  AppLogger.instance.info('Localization initialized', tag: 'Main');

  // Initialize dependency injection
  await di.init();
  AppLogger.instance.info('Dependency injection initialized', tag: 'Main');

  // Initialize connection service
  Get.put(di.sl<ConnectionService>());
  AppLogger.instance.info('Connection service initialized', tag: 'Main');

  // Initialize localization service in GetX
  Get.put(LocalizationService.instance);
  AppLogger.instance.info('Localization service registered', tag: 'Main');

  runApp(const BookPalmApp());
}

class BookPalmApp extends StatelessWidget {
  const BookPalmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: LocalizationService.instance.translate('app.name'),
      theme: AppTheme.lightTheme,
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
    );
  }
}
