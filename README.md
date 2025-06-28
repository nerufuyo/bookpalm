# BookPalm

A modern Flutter application for browsing and managing books from the Project Gutenberg digital library. BookPalm provides an intuitive interface for discovering, searching, and bookmarking free eBooks with comprehensive filtering and categorization features.

## Features

- **Book Discovery**: Browse thousands of free books from Project Gutenberg
- **Advanced Search**: Search books by title, author, or subject
- **Smart Filtering**: Filter by categories, languages, and download count
- **Bookmark Management**: Save favorite books for easy access
- **Enhanced Book Detail UI**: Beautiful book cover displays with subtle background gradients and optimized floating action buttons
- **Comprehensive Offline Support**: Full offline functionality with intelligent caching
- **Real-time Sync**: Automatic data synchronization when connection is restored
- **Cache Management**: Built-in tools to manage offline data storage
- **Modern UI**: Material Design 3 with responsive layouts and nature-inspired color palette
- **Multi-platform**: Supports Android, iOS, Web, Windows, macOS, and Linux
- **Internationalization**: Full multi-language support with instant language switching

## 🎨 Design System

BookPalm features a carefully crafted design system with a nature-inspired color palette that creates a calming and professional reading environment.

### Color Palette

- **Primary Green (`#2F5249`)**: Represents stability, growth, and knowledge
- **Secondary Green (`#437057`)**: Provides harmony and balance in the interface  
- **Accent Green (`#97B067`)**: Suggests wisdom and tranquility for focused reading
- **Highlight Yellow (`#E3DE61`)**: Adds warmth and highlights important information
- **Background (`#FBFBFB`)**: Creates a clean, paper-like reading experience

### Typography

BookPalm uses **Poppins**, a modern geometric sans-serif typeface that provides:
- Excellent multilingual support for our international user base
- High readability at all sizes
- Modern, friendly appearance
- Perfect support for English, Indonesian, German, Japanese, Chinese, and Korean

### Recent UI Improvements

#### Book Detail Page Enhancements
- **Book Cover Background**: Added subtle gradient background with green tint at 0.15 opacity for enhanced visual appeal
- **Optimized Floating Action Button**: Simplified from extended text button to clean icon-only design
  - Uses intuitive bookmark icons (bookmark_add/bookmark_remove)
  - Color-coded: Green for adding bookmarks, Red for removing
  - Eliminates text overflow issues while maintaining clear functionality

## 🌍 Localization & Internationalization

BookPalm supports multiple languages with a comprehensive localization system that allows instant language switching throughout the entire app.

### Supported Languages

- **English (en)** - Default language
- **Indonesian (id)** - Bahasa Indonesia
- **German (de)** - Deutsch
- **Japanese (ja)** - 日本語
- **Chinese (zh)** - 中文
- **Korean (ko)** - 한국어

### Key Localization Features

- **🔄 Instant Language Switching**: Changes apply immediately across the entire app
- **💾 Persistent Selection**: Language preference is saved and restored on app restart
- **🎯 Complete Coverage**: All UI strings, buttons, messages, and content are localized
- **⚡ Reactive Updates**: All screens and widgets update automatically when language changes
- **🛠️ Easy Maintenance**: JSON-based translation system for easy content management
- **📝 Parameter Support**: Dynamic content with placeholders (e.g., "Welcome, {name}!")

### How to Change Language

1. Open the app and navigate to the **Settings** tab
2. Tap on **Language** option
3. Select your preferred language from the dropdown
4. The app will instantly switch to the selected language
5. Your choice is automatically saved for future app launches

### Technical Implementation

#### Translation Files Structure
```
assets/translations/
├── en.json          # English (default)
├── id.json          # Indonesian
├── de.json          # German
├── ja.json          # Japanese
├── zh.json          # Chinese
└── ko.json          # Korean
```

#### Translation Keys Organization
```json
{
  "app": {
    "title": "BookPalm",
    "subtitle": "Discover Free Books"
  },
  "navigation": {
    "home": "Home",
    "bookmarks": "Bookmarks",
    "settings": "Settings"
  },
  "actions": {
    "search": "Search",
    "filter": "Filter",
    "bookmark": "Bookmark",
    "share": "Share"
  },
  "messages": {
    "loading": "Loading...",
    "error": "An error occurred",
    "success": "Operation completed successfully",
    "offline": "You're offline. Showing cached content.",
    "connection_restored": "Connection restored. Syncing data..."
  }
}
```

#### LocalizationService Features

The `LocalizationService` provides:

- **Reactive Translation**: Using GetX for instant UI updates
- **Parameter Interpolation**: Support for dynamic content like `"Hello, {name}!"`
- **Fallback Mechanism**: Falls back to English if translation is missing
- **Type Safety**: Compile-time checking of translation keys
- **Performance**: Efficient caching of loaded translations

#### Usage in Code

```dart
// Simple translation
Text(LocalizationService.instance.translate('navigation.home'))

// Translation with parameters
Text(LocalizationService.instance.translate('messages.welcome', {'name': 'John'}))

// Using GetX for reactive updates
Obx(() => Text(LocalizationService.instance.translate('app.title')))
```

### For Developers & Contributors

#### Adding New Languages

1. **Create Translation File**: Add a new JSON file in `assets/translations/` (e.g., `fr.json` for French)
2. **Copy Structure**: Use `en.json` as a template and translate all values
3. **Update LocalizationService**: Add the new language to `supportedLanguages` list
4. **Update Settings**: Add the language option to the settings dropdown
5. **Test**: Verify all UI elements display correctly in the new language

#### Adding New Translation Keys

1. **Add to English**: First add the new key-value pair to `en.json`
2. **Translate**: Add the same key with translated values to all other language files
3. **Use in Code**: Reference the new key in your widgets/controllers
4. **Test**: Verify the translation appears correctly in all supported languages

#### Translation Guidelines

- **Keep Keys Descriptive**: Use hierarchical keys like `settings.language.title`
- **Maintain Consistency**: Use the same key structure across all language files
- **Handle Pluralization**: Use parameters for dynamic content that changes based on count
- **Consider Context**: Some words may have different translations in different contexts
- **Test Thoroughly**: Always test UI layout with longer/shorter translated text

### Localization Assets Setup

Update `pubspec.yaml` to include translation assets:

```yaml
flutter:
  assets:
    - assets/translations/
```

### Dependencies for Localization

```yaml
dependencies:
  get: ^4.6.6                 # State management and reactivity
  shared_preferences: ^2.3.2  # Persistent language storage
```

### Future Localization Enhancements

Planned features for future releases:

- **Right-to-Left (RTL) Support**: For Arabic, Hebrew, and other RTL languages
- **Pluralization Rules**: Advanced plural forms for different languages
- **Date/Number Formatting**: Locale-specific formatting
- **Currency Support**: Multi-currency display for paid content
- **Dynamic Translation Loading**: Download translations on-demand
- **Translation Management**: Admin interface for managing translations

### Troubleshooting Localization

#### Common Issues and Solutions

1. **Missing Translations**: If text appears as keys (e.g., "settings.title"), check if the key exists in the current language file
2. **Layout Issues**: Some languages may have longer text - ensure UI components can accommodate varying text lengths
3. **Special Characters**: Ensure proper UTF-8 encoding in JSON files for special characters
4. **Parameter Issues**: When using parameters, ensure the placeholder names match exactly

For detailed localization development information, see [`LOCALIZATION_GUIDE.md`](./LOCALIZATION_GUIDE.md).

## 🔄 Offline Mode

BookPalm features comprehensive offline functionality, ensuring users can continue reading and browsing even without an internet connection.

### Key Offline Features

- **📱 Seamless Offline Experience**: Continue using the app when internet is unavailable
- **💾 Intelligent Caching**: Automatically cache books and search results for offline access
- **🔍 Offline Search**: Browse previously cached search results without internet
- **📚 Offline Bookmarks**: Access all bookmarked books regardless of connection status
- **⚡ Fast Loading**: Cached content loads instantly without network delays
- **🔄 Auto-Sync**: Automatically sync new data when connection is restored
- **⚙️ Cache Management**: Full control over cached data through settings

### How Offline Mode Works

#### When Online:
- App fetches fresh data from Project Gutenberg API
- Successful responses are automatically cached in local SQLite database
- Users can browse, search, and bookmark normally
- Connection status displays "Connected to Internet" in settings

#### When Offline:
- App detects loss of internet connection
- Orange banner appears: "You're offline. Showing cached content."
- App serves previously cached data instead of showing errors
- All core functionality remains available:
  - Browse previously viewed books
  - Access complete bookmark collection
  - View cached search results
  - Read detailed book information
  - Navigate between all cached content

#### When Connection Restored:
- Green notification appears: "Connection restored. Syncing data..."
- App automatically resumes online operation
- New requests fetch fresh data from the internet
- Cache is updated with latest content

### Technical Implementation

#### Database & Caching
```sql
-- Cached individual books
CREATE TABLE cached_books (
  id INTEGER PRIMARY KEY,
  book_data TEXT NOT NULL,
  cached_at INTEGER NOT NULL
);

-- Cached book list responses (search results)
CREATE TABLE cached_book_lists (
  list_key TEXT PRIMARY KEY,
  list_data TEXT NOT NULL,
  page INTEGER NOT NULL,
  cached_at INTEGER NOT NULL
);
```

#### Cache Strategy
1. **Network First**: Always attempt to fetch fresh data when online
2. **Cache on Success**: Store all successful API responses locally
3. **Fallback to Cache**: Serve cached data when network is unavailable
4. **Smart Expiration**: Automatically clean up cache entries older than 7 days
5. **Selective Caching**: Cache both individual books and search result lists

#### Architecture Components
- **DatabaseHelper**: SQLite database management for offline storage
- **ConnectionService**: Real-time connectivity monitoring with GetX
- **Enhanced Repository Pattern**: Network-first with intelligent cache fallbacks
- **Offline Indicators**: Visual feedback for connection status

### Settings & Cache Management

Access comprehensive cache management through the Settings tab:

#### Connection Status
- Real-time display of internet connectivity
- Visual indicators for online/offline state
- Connection history and status changes

#### Cache Statistics
- Number of cached books
- Number of cached search lists
- Total cache size information
- Last cache update timestamp

#### Cache Controls
- **Refresh Stats**: Update cache statistics display
- **Clear All Cache**: Remove all cached content (preserves bookmarks)
- **Automatic Cleanup**: Configure cache expiration settings

### Dependencies for Offline Mode
```yaml
dependencies:
  sqflite: ^2.4.1              # Local SQLite database
  path: ^1.9.0                 # Database path utilities
  connectivity_plus: ^6.0.5    # Connection monitoring
  shared_preferences: ^2.3.2   # Persistent bookmark storage
```

### Testing Offline Functionality

1. **Populate Cache**: 
   - Run app with internet connection
   - Browse several books and perform searches
   - Add bookmarks to test offline bookmark access

2. **Test Offline Mode**:
   - Disable internet connection on device
   - Navigate through the app
   - Verify cached content loads properly
   - Check offline indicator appears

3. **Test Connection Restoration**:
   - Re-enable internet connection
   - Verify "Connection restored" notification
   - Confirm fresh data fetching resumes

### Performance Benefits

- **⚡ Instant Loading**: Cached content loads without network latency
- **📊 Reduced Data Usage**: Fewer API calls for repeated content
- **🔋 Battery Efficiency**: Less network activity preserves device battery
- **🌐 Poor Connection Handling**: Graceful degradation in low-connectivity areas
- **💾 Smart Storage**: Automatic cache management prevents storage bloat

## Architecture

BookPalm follows Clean Architecture principles with clear separation of concerns:

### Project Structure

```
lib/
├── core/                    # Core functionality and utilities
│   ├── database/           # SQLite database management
│   ├── localization/       # Internationalization support and translation service
│   ├── logging/            # Centralized logging system
│   ├── network/            # Network connectivity utilities
│   └── services/           # Core services (connection monitoring)
├── data/                   # Data layer implementation
│   ├── datasources/        # API and local data sources (with caching)
│   ├── models/            # Data models and JSON serialization
│   └── repositories/       # Repository implementations (offline-enabled)
├── domain/                 # Business logic layer
│   ├── entities/          # Core business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/          # Business use cases
└── presentation/           # UI layer
    ├── controllers/        # State management controllers (including localization)
    ├── pages/             # Application screens (including multilingual settings)
    ├── routes/            # Navigation configuration
    └── widgets/           # Reusable UI components (with localization support)

assets/
└── translations/           # Localization files (JSON format)
    ├── en.json            # English (default)
    ├── id.json            # Indonesian
    ├── de.json            # German
    ├── ja.json            # Japanese
    ├── zh.json            # Chinese
    └── ko.json            # Korean

test/                       # Comprehensive test suite
├── core/                  # Core functionality tests (including localization)
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
- **GetX**: ^4.6.6 - State management, dependency injection, routing, and localization reactivity
- **GetIt**: ^7.7.0 - Service locator for dependency injection
- **GoRouter**: ^14.2.7 - Declarative routing

### Networking & Data
- **HTTP**: ^1.2.2 - HTTP client for API calls
- **JSON Annotation**: ^4.9.0 - JSON serialization
- **Shared Preferences**: ^2.3.2 - Local data persistence
- **SQLite**: ^2.4.1 - Local database for offline caching
- **Path**: ^1.9.0 - File system path utilities

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

4. **Configure localization assets** (already included in pubspec.yaml)
   ```yaml
   flutter:
     assets:
       - assets/translations/
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

### First Run Setup

When running BookPalm for the first time:

1. **Internet Connection Required**: Initial setup requires internet to fetch book data
2. **Language Selection**: Choose your preferred language in Settings → Language
3. **Automatic Cache Population**: Browse books to automatically build offline cache
4. **Bookmark Setup**: Add bookmarks for guaranteed offline access
5. **Settings Configuration**: Visit Settings tab to view cache status and manage offline data

### Testing Localization

To test the multi-language functionality:

1. **Language Switching**: Go to Settings → Language and try different languages
2. **UI Coverage**: Navigate through all screens to verify complete translation
3. **Persistence**: Close and reopen app to confirm language selection is saved
4. **Reactivity**: Change language and observe instant UI updates without restart
5. **Parameter Testing**: Look for dynamic content like error messages and notifications

### Offline Mode Testing

To test offline functionality:

1. **Build Cache**: Use app online to cache content
2. **Disable Network**: Turn off WiFi/cellular data
3. **Test Offline**: Navigate app with offline indicator
4. **Restore Network**: Re-enable connection to see sync notifications

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

BookPalm integrates with the Project Gutenberg API with intelligent offline fallbacks:

- **Base URL**: `https://gutendex.com/`
- **Books Endpoint**: `/books/`
- **Search**: Query parameters for filtering and search
- **Pagination**: Supports offset-based pagination
- **Offline Caching**: All successful API responses are automatically cached
- **Fallback Strategy**: Serves cached data when API is unavailable

### Offline API Behavior

- **Online**: Direct API calls with automatic caching of responses
- **Offline**: Serves cached API responses transparently
- **Partial Connectivity**: Graceful fallback when API requests fail
- **Connection Restoration**: Automatic sync when connectivity returns

## Contributing

We welcome contributions to BookPalm! Here's how you can help:

### General Contributions

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes and add tests
4. Ensure all tests pass: `flutter test`
5. Ensure code quality: `flutter analyze`
6. Commit your changes: `git commit -m 'feat: add new feature'`
7. Push to the branch: `git push origin feature/new-feature`
8. Submit a pull request

### Localization Contributions

We especially welcome contributions for:

- **New Language Support**: Help us add more languages to BookPalm
- **Translation Improvements**: Better translations for existing languages
- **Localization Features**: RTL support, pluralization, date formatting

To contribute translations:

1. **Add New Language**: Create a new JSON file in `assets/translations/`
2. **Follow Guidelines**: Use the detailed guidelines in [`LOCALIZATION_GUIDE.md`](./LOCALIZATION_GUIDE.md)
3. **Test Thoroughly**: Ensure UI layouts work well with the new language
4. **Update Code**: Add the new language to supported languages list
5. **Submit PR**: Include screenshots showing the new language in action

### Translation Quality Standards

- **Accuracy**: Translations should be contextually appropriate
- **Consistency**: Use consistent terminology throughout the app
- **Cultural Sensitivity**: Consider cultural nuances in translations
- **UI Testing**: Verify that translated text fits well in UI components

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Project Gutenberg for providing free eBook access
- Flutter team for the excellent framework
- Open source community for the amazing packages
