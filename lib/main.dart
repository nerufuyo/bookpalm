import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/localization/localization_service.dart';
import 'core/logging/app_logger.dart';
import 'presentation/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.instance.initialize();
  AppLogger.instance.info('Application starting...', tag: 'Main');

  // Initialize localization
  await LocalizationService.instance.loadLanguage('en');
  AppLogger.instance.info('Localization initialized', tag: 'Main');

  // Initialize dependency injection
  await di.init();
  AppLogger.instance.info('Dependency injection initialized', tag: 'Main');

  runApp(const BookPalmApp());
}

class BookPalmApp extends StatelessWidget {
  const BookPalmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'BookPalm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
    );
  }
}
