import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../controllers/home_controller.dart';
import '../widgets/book_card.dart';
import '../widgets/book_card_shimmer.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_tabs.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/offline_indicator.dart';
import '../../core/injection/injection_container.dart' as di;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(di.sl<HomeController>());

    return OfflineWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: GetBuilder<LocalizationService>(
            init: LocalizationService.instance,
            builder: (localization) => Text(
              LocalizationService.instance.translate('pages.home.title'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showFilterBottomSheet(context, controller);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(
                onSearchChanged: controller.searchBooks,
                onSearchSubmitted: controller.searchBooks,
              ),
            ),

            // Category Tabs
            Obx(
              () => CategoryTabs(
                categories: controller.categories,
                selectedCategory: controller.selectedCategory.value,
                onCategorySelected: controller.selectCategory,
              ),
            ),

            // Books List
            Expanded(
              child: Obx(() {
                if (controller.books.isEmpty && controller.isLoading.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6, // Show 6 shimmer cards
                    itemBuilder: (context, index) => const BookCardShimmer(),
                  );
                }

                if (controller.books.isEmpty && !controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value.isNotEmpty
                              ? controller.errorMessage.value
                              : LocalizationService.instance.translate(
                                  'pages.home.noBooksFound',
                                ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (controller.errorMessage.value.isNotEmpty)
                          const SizedBox(height: 16),
                        if (controller.errorMessage.value.isNotEmpty)
                          ElevatedButton(
                            onPressed: () =>
                                controller.loadBooks(isRefresh: true),
                            child: GetBuilder<LocalizationService>(
                              init: LocalizationService.instance,
                              builder: (localization) => Text(
                                LocalizationService.instance.translate(
                                  'pages.home.retry',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadBooks(isRefresh: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        controller.books.length +
                        (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.books.length) {
                        // Loading indicator for pagination
                        if (controller.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          // Load more button or trigger
                          controller.loadMoreBooks();
                          return const SizedBox.shrink();
                        }
                      }

                      final book = controller.books[index];
                      return Obx(
                        () => BookCard(
                          book: book,
                          isBookmarked: controller.isBookmarked(book),
                          onTap: () {
                            context.push('/book/${book.id}');
                          },
                          onBookmarkTap: () {
                            controller.toggleBookmark(
                              book,
                              onSuccess: (message) {
                                try {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      backgroundColor: Colors.green.shade600,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } catch (e) {
                                  // Widget tree might be disposed, ignore
                                }
                              },
                              onError: (message) {
                                try {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      backgroundColor: Colors.red.shade600,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                } catch (e) {
                                  // Widget tree might be disposed, ignore
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, HomeController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(controller: controller),
    );
  }
}
