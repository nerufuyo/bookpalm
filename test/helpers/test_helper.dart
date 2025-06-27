import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:bookpalm/core/logging/app_logger.dart';

/// Helper function to set up basic test environment
/// This initializes logging and basic dependencies for tests
Future<void> setupTestEnvironment() async {
  // Initialize logger if not already initialized
  try {
    AppLogger.instance.initialize();
  } catch (e) {
    // Logger already initialized, ignore
  }
}

/// Helper function to reset GetIt for tests
Future<void> resetDependencies() async {
  await GetIt.instance.reset();
}

/// Helper function to tear down test environment
Future<void> tearDownTestEnvironment() async {
  await GetIt.instance.reset();
}
