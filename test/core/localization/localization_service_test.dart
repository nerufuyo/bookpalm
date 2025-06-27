import 'package:flutter_test/flutter_test.dart';
import 'package:bookpalm/core/localization/localization_service.dart';

void main() {
  group('LocalizationService', () {
    test('should return singleton instance', () {
      final instance1 = LocalizationService.instance;
      final instance2 = LocalizationService.instance;
      expect(instance1, same(instance2));
    });

    test('should handle translation with fallback', () {
      final service = LocalizationService.instance;

      // Test fallback when key doesn't exist
      final result = service.translate('non.existent.key');
      expect(result, equals('non.existent.key'));
    });

    test('should handle empty keys', () {
      final service = LocalizationService.instance;

      expect(service.translate(''), equals(''));
    });

    test('should have valid AppStrings constants', () {
      // Test that AppStrings constants are valid strings
      expect(AppStrings.bookDetailLoading, isA<String>());
      expect(AppStrings.bookDetailLoading.isNotEmpty, isTrue);

      expect(AppStrings.bookDetailErrorTitle, isA<String>());
      expect(AppStrings.bookDetailErrorTitle.isNotEmpty, isTrue);

      expect(AppStrings.bookDetailRetryButton, isA<String>());
      expect(AppStrings.bookDetailRetryButton.isNotEmpty, isTrue);

      expect(AppStrings.genresFiction, isA<String>());
      expect(AppStrings.genresFiction.isNotEmpty, isTrue);
    });

    test('should provide LocalizationExtension functionality', () {
      final testKey = 'test.key';
      final service = LocalizationService.instance;

      // Test that extension method works the same as direct method call
      expect(testKey.tr, equals(service.translate(testKey)));
    });

    test('should handle edge cases gracefully', () {
      final service = LocalizationService.instance;

      // Test with special characters
      expect(service.translate('key.with.special-chars_123'), isA<String>());

      // Test with very long key
      final longKey = 'very.' * 100 + 'long.key';
      expect(service.translate(longKey), equals(longKey));
    });

    test('should return current language', () {
      final service = LocalizationService.instance;

      // Default language should be 'en'
      expect(service.currentLanguage, equals('en'));
    });
  });
}
