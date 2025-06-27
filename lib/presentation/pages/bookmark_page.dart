import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/bookmark_controller.dart';
import '../widgets/bookmark_card.dart';
import '../widgets/empty_bookmarks_widget.dart';
import '../widgets/bookmark_loading_widget.dart';
import '../../core/injection/injection_container.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late final BookmarkController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<BookmarkController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Obx(() {
            if (_controller.bookmarkedBooks.isNotEmpty) {
              return IconButton(
                onPressed: () => _controller.refreshBookmarks(),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.black87,
                ),
                tooltip: 'Refresh',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const BookmarkLoadingWidget();
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return _buildErrorWidget();
        }

        if (_controller.bookmarkedBooks.isEmpty) {
          return EmptyBookmarksWidget(
            onBrowseBooksPressed: () {
              // Navigate to home page
              context.go('/');
            },
          );
        }

        return _buildBookmarksList();
      }),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _controller.refreshBookmarks(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList() {
    return RefreshIndicator(
      onRefresh: () => _controller.refreshBookmarks(),
      color: Colors.amber.shade600,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _controller.bookmarkedBooks.length,
        itemBuilder: (context, index) {
          final book = _controller.bookmarkedBooks[index];
          return BookmarkCard(
            book: book,
            onTap: () {
              context.push('/book/${book.id}', extra: book);
            },
            onRemoveBookmark: () {
              _controller.removeBookmarkById(book);
            },
          );
        },
      ),
    );
  }
}
