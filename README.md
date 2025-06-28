# BookPalm

A modern Flutter application for browsing and managing books from the Project Gutenberg digital library. BookPalm provides an intuitive interface for discovering, searching, and bookmarking free eBooks with comprehensive filtering and categorization features.

## Features

- **Book Discovery**: Browse thousands of free books from Project Gutenberg
- **Advanced Search**: Search books by title, author, or subject
- **Smart Filtering**: Filter by categories, languages, and download count
- **Bookmark Management**: Save favorite books for easy access
- **Comprehensive Offline Support**: Full offline functionality with intelligent caching
- **Real-time Sync**: Automatic data synchronization when connection is restored
- **Cache Management**: Built-in tools to manage offline data storage
- **Modern UI**: Material Design 3 with responsive layouts
- **Multi-platform**: Supports Android, iOS, Web, Windows, macOS, and Linux

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
│   ├── localization/       # Internationalization support
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
    ├── controllers/        # State management controllers
    ├── pages/             # Application screens (including settings)
    ├── routes/            # Navigation configuration
    └── widgets/           # Reusable UI components (offline indicators)

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

4. **Run the application**
   ```bash
   flutter run
   ```

### First Run Setup

When running BookPalm for the first time:

1. **Internet Connection Required**: Initial setup requires internet to fetch book data
2. **Automatic Cache Population**: Browse books to automatically build offline cache
3. **Bookmark Setup**: Add bookmarks for guaranteed offline access
4. **Settings Configuration**: Visit Settings tab to view cache status and manage offline data

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
