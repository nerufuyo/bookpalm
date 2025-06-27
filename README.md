# BookPalm

A modern Flutter application for browsing and managing books from the Project Gutenberg digital library. BookPalm provides an intuitive interface for discovering, searching, and bookmarking free eBooks with comprehensive filtering and categorization features.

## Features

- **Book Discovery**: Browse thousands of free books from Project Gutenberg
- **Advanced Search**: Search books by title, author, or subject
- **Smart Filtering**: Filter by categories, languages, and download count
- **Bookmark Management**: Save favorite books for easy access
- **Offline Support**: Access bookmarked books without internet connection
- **Modern UI**: Material Design 3 with responsive layouts
- **Multi-platform**: Supports Android, iOS, Web, Windows, macOS, and Linux

## Architecture

BookPalm follows Clean Architecture principles with clear separation of concerns:

### Project Structure

```
lib/
├── core/                    # Core functionality and utilities
│   ├── localization/       # Internationalization support
│   └── logging/            # Centralized logging system
├── data/                   # Data layer implementation
│   ├── datasources/        # API and local data sources
│   ├── models/            # Data models and JSON serialization
│   └── repositories/       # Repository implementations
├── domain/                 # Business logic layer
│   ├── entities/          # Core business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/          # Business use cases
└── presentation/           # UI layer
    ├── controllers/        # State management controllers
    ├── pages/             # Application screens
    ├── routes/            # Navigation configuration
    └── widgets/           # Reusable UI components

test/                       # Comprehensive test suite
├── core/                  # Core functionality tests
├── data/                  # Data layer tests
├── domain/                # Domain layer tests
└── presentation/          # UI and controller tests
```

### Architecture Patterns

- **Clean Architecture**: Separation of concerns with clear layer boundaries
- **Repository Pattern**: Abstraction of data sources
- **UseCase Pattern**: Encapsulation of business logic
- **Dependency Injection**: Using GetIt for dependency management
- **State Management**: GetX for reactive state management
- **Navigation**: GoRouter for declarative routing

## Technology Stack

### Core Framework
- **Flutter**: ^3.8.1 - Cross-platform UI framework
- **Dart**: Modern programming language

### State Management & Architecture
- **GetX**: ^4.6.6 - State management, dependency injection, and routing
- **GetIt**: ^7.7.0 - Service locator for dependency injection
- **GoRouter**: ^14.2.7 - Declarative routing

### Networking & Data
- **HTTP**: ^1.2.2 - HTTP client for API calls
- **JSON Annotation**: ^4.9.0 - JSON serialization
- **Shared Preferences**: ^2.3.2 - Local data persistence

### UI & UX
- **Material Design 3**: Modern design system
- **Cached Network Image**: ^3.4.1 - Efficient image loading and caching
- **Connectivity Plus**: ^6.0.5 - Network connectivity monitoring

### Development Tools
- **Flutter Lints**: ^5.0.0 - Code quality and style enforcement
- **Build Runner**: ^2.4.12 - Code generation
- **Mockito**: ^5.4.4 - Test mocking framework

## Installation

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/nerufuyo/bookpalm.git
   cd bookpalm
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

For development with hot reload:
```bash
flutter run --debug
```

For production builds:
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Testing

BookPalm includes a comprehensive test suite with 147+ tests covering unit tests, widget tests, and integration tests.

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories
```bash
# Unit tests only
flutter test test/domain/ test/data/

# Widget tests only
flutter test test/presentation/widgets/

# Controller tests only
flutter test test/presentation/controllers/
```

### Test Coverage
```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Using Automation Scripts
```bash
# Use provided Makefile
make test

# Use test script
./test_all.sh
```

## Code Quality

### Static Analysis
```bash
flutter analyze
```

### Code Formatting
```bash
dart format .
```

### Linting
The project follows Flutter's recommended linting rules defined in `analysis_options.yaml`.

## API Integration

BookPalm integrates with the Project Gutenberg API to fetch book data:

- **Base URL**: `https://gutendex.com/`
- **Books Endpoint**: `/books/`
- **Search**: Query parameters for filtering and search
- **Pagination**: Supports offset-based pagination

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes and add tests
4. Ensure all tests pass: `flutter test`
5. Ensure code quality: `flutter analyze`
6. Commit your changes: `git commit -m 'feat: add new feature'`
7. Push to the branch: `git push origin feature/new-feature`
8. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Project Gutenberg for providing free eBook access
- Flutter team for the excellent framework
- Open source community for the amazing packages
