import 'package:go_router/go_router.dart';
import '../pages/splash_page.dart';
import '../pages/home_page.dart';
import '../pages/bookmark_page.dart';
import '../pages/book_detail_page.dart';
import '../widgets/main_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Main App Shell
      ShellRoute(
        builder: (context, state, child) {
          final location = state.matchedLocation;
          int currentIndex = 0;

          if (location.startsWith('/bookmarks')) {
            currentIndex = 1;
          }

          return MainLayout(currentIndex: currentIndex, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/bookmarks',
            name: 'bookmarks',
            builder: (context, state) => const BookmarkPage(),
          ),
        ],
      ),

      // Book Detail
      GoRoute(
        path: '/book/:id',
        name: 'book-detail',
        builder: (context, state) {
          final bookId = state.pathParameters['id']!;
          return BookDetailPage(bookId: bookId);
        },
      ),
    ],
  );
}
