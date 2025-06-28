import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/person.dart';
import '../../core/injection/injection_container.dart' as di;
import '../../core/localization/localization_service.dart';
import '../../core/logging/app_logger.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late BookDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(di.sl<BookDetailController>());
    AppLogger.instance.info(
      'BookDetailPage initialized',
      tag: 'BookDetailPage',
    );
    controller.loadBookDetails(int.parse(widget.bookId));
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.instance.debug('Building BookDetailPage', tag: 'BookDetailPage');
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoadingRx.value) {
          return _buildLoadingWidget();
        }

        if (controller.errorMessageRx.value.isNotEmpty) {
          return _buildErrorWidget();
        }

        if (controller.bookRx.value == null) {
          return _buildNotFoundWidget();
        }

        return _buildBookDetails(controller.bookRx.value!);
      }),
      floatingActionButton: Obx(() {
        if (controller.bookRx.value != null && !controller.isLoadingRx.value) {
          return _buildBookmarkFAB();
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.green),
          const SizedBox(height: 16),
          Text(
            LocalizationService.instance.translate(
              AppStrings.bookDetailLoading,
            ),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            LocalizationService.instance.translate(
              AppStrings.bookDetailErrorTitle,
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessageRx.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                controller.loadBookDetails(int.parse(widget.bookId)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              LocalizationService.instance.translate(
                AppStrings.bookDetailRetryButton,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            LocalizationService.instance.translate(
              AppStrings.bookDetailNotFoundTitle,
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            LocalizationService.instance.translate(
              AppStrings.bookDetailNotFoundMessage,
            ),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildBookDetails(Book book) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(book),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookInfo(book),
                const SizedBox(height: 24),
                _buildAuthorDetails(book),
                const SizedBox(height: 24),
                _buildBookDescription(book),
                const SizedBox(height: 24),
                _buildPublicationInfo(book),
                const SizedBox(height: 24),
                _buildLanguagesSection(book),
                const SizedBox(height: 24),
                _buildCategoriesSection(book),
                const SizedBox(height: 24),
                _buildAvailableFormats(book),
                const SizedBox(height: 24),
                _buildReadingStatistics(book),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Book book) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.withValues(alpha: 0.15), Colors.grey[100]!],
            ),
          ),
          child: Center(
            child: Hero(
              tag: 'book-${book.id}',
              child: Container(
                width: 180,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: book.formats['image/jpeg'] != null
                      ? Image.network(
                          book.formats['image/jpeg']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildBookCoverPlaceholder(),
                        )
                      : _buildBookCoverPlaceholder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCoverPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade300, Colors.green.shade600],
        ),
      ),
      child: const Center(
        child: Icon(Icons.book, size: 60, color: Colors.white),
      ),
    );
  }

  Widget _buildBookInfo(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        if (book.authors.isNotEmpty)
          Text(
            'by ${book.authors.map((author) => author.name).join(', ')}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'ID: ${book.id}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${book.downloadCount} ${LocalizationService.instance.translate(AppStrings.bookDetailDownloads)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthorDetails(Book book) {
    if (book.authors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 20, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  book.authors.length > 1
                      ? LocalizationService.instance.translate(
                          AppStrings.bookDetailAuthors,
                        )
                      : LocalizationService.instance.translate(
                          AppStrings.bookDetailAuthor,
                        ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...book.authors.map(
              (author) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (author.birthYear != null ||
                              author.deathYear != null)
                            Text(
                              _formatAuthorLifespan(author),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAuthorLifespan(Person author) {
    if (author.birthYear != null && author.deathYear != null) {
      return '(${author.birthYear} - ${author.deathYear})';
    } else if (author.birthYear != null) {
      return '(Born ${author.birthYear})';
    } else if (author.deathYear != null) {
      return '(Died ${author.deathYear})';
    }
    return '';
  }

  Widget _buildBookDescription(Book book) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, size: 20, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text(
                  LocalizationService.instance.translate(
                    AppStrings.bookDetailAboutThisBook,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDescriptionContent(book),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionContent(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainDescription(book),
        const SizedBox(height: 16),
        _buildTopicalSummary(book),
        const SizedBox(height: 16),
        _buildHistoricalContext(book),
      ],
    );
  }

  Widget _buildMainDescription(Book book) {
    String description = _generateMainDescription(book);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Colors.grey[800],
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  String _generateMainDescription(Book book) {
    List<String> descriptionParts = [];

    // Generate genre-specific descriptions
    if (book.subjects.isNotEmpty) {
      String genre = _getGenreDescription(book.subjects);
      descriptionParts.add(genre);
    }

    // Author context
    if (book.authors.isNotEmpty) {
      String authorContext = _getAuthorContext(book.authors);
      descriptionParts.add(authorContext);
    }

    // Literary significance
    if (book.bookshelves.isNotEmpty) {
      String significance = _getLiterarySignificance(book.bookshelves.first);
      descriptionParts.add(significance);
    }

    // Popularity and accessibility
    descriptionParts.add(_getPopularityDescription(book.downloadCount));

    return descriptionParts.join(' ');
  }

  String _getGenreDescription(List<String> subjects) {
    Map<String, String> genreDescriptions = {
      'Fiction':
          'This captivating work of fiction transports readers through compelling narratives and rich character development.',
      'Fantasy':
          'Immerse yourself in a world of magic, adventure, and fantastical creatures in this enchanting tale.',
      'Science fiction':
          'Explore futuristic concepts and technological wonders in this thought-provoking science fiction narrative.',
      'Romance':
          'Experience the beauty of love and human connection in this heartwarming romantic story.',
      'Mystery':
          'Unravel secrets and solve puzzles in this gripping mystery that will keep you guessing until the end.',
      'Adventure':
          'Embark on thrilling journeys and exciting escapades in this action-packed adventure.',
      'Historical':
          'Step back in time and experience history through engaging storytelling and authentic period details.',
      'Biography':
          'Discover the fascinating life story and achievements of remarkable individuals.',
      'Philosophy':
          'Delve into deep philosophical questions and explore fundamental aspects of human existence.',
      'Poetry':
          'Experience the beauty of language and emotion through carefully crafted verses and lyrical expression.',
    };

    for (String subject in subjects) {
      for (String genre in genreDescriptions.keys) {
        if (subject.toLowerCase().contains(genre.toLowerCase())) {
          return genreDescriptions[genre]!;
        }
      }
    }

    return 'This remarkable work explores themes of ${subjects.take(3).join(', ').toLowerCase()}, offering readers a rich and engaging literary experience.';
  }

  String _getAuthorContext(List<Person> authors) {
    if (authors.length == 1) {
      Person author = authors.first;
      String era = _getAuthorEra(author);
      return 'Crafted by ${author.name}$era, this work showcases the distinctive style and insights that have captivated readers across generations.';
    } else {
      return 'This collaborative masterpiece brings together the unique perspectives of ${authors.length} talented authors, creating a rich tapestry of ideas and storytelling.';
    }
  }

  String _getAuthorEra(Person author) {
    if (author.birthYear != null) {
      if (author.birthYear! < 1800) {
        return ', a distinguished author of the classical era,';
      } else if (author.birthYear! < 1900) {
        return ', a celebrated 19th-century writer,';
      } else if (author.birthYear! < 1950) {
        return ', an influential early 20th-century author,';
      } else {
        return ', a contemporary literary voice,';
      }
    }
    return '';
  }

  String _getLiterarySignificance(String bookshelf) {
    Map<String, String> shelfDescriptions = {
      'Best Books Ever Listings':
          'Recognized as one of the finest literary works ever created, this book has earned its place among the greatest achievements in literature.',
      'Harvard Classics':
          'Part of the prestigious Harvard Classics collection, this work represents essential reading for any well-rounded education.',
      'Children\'s Literature':
          'A beloved classic that has delighted young readers for generations while imparting valuable lessons and sparking imagination.',
      'Gothic Fiction':
          'A masterful example of gothic literature, blending mystery, romance, and supernatural elements to create an atmospheric reading experience.',
      'Science Fiction':
          'A pioneering work in the science fiction genre, this book has influenced countless authors and continues to inspire new generations of readers.',
    };

    return shelfDescriptions[bookshelf] ??
        'This distinguished work holds a special place in literary collections and continues to be appreciated by discerning readers.';
  }

  String _getPopularityDescription(int downloadCount) {
    if (downloadCount > 10000) {
      return 'With over ${_formatNumber(downloadCount)} downloads, this exceptionally popular work has touched the lives of readers worldwide, establishing itself as a true classic of digital literature.';
    } else if (downloadCount > 5000) {
      return 'Downloaded ${_formatNumber(downloadCount)} times, this well-regarded work has found its way into the hearts and minds of readers around the globe.';
    } else if (downloadCount > 1000) {
      return 'With ${_formatNumber(downloadCount)} downloads, this engaging work continues to attract new readers and build its reputation.';
    } else {
      return 'This intriguing work offers readers a unique literary experience and continues to discover new audiences.';
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildTopicalSummary(Book book) {
    if (book.subjects.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.topic_outlined, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 6),
              Text(
                LocalizationService.instance.translate(
                  AppStrings.bookDetailKeyThemesTopics,
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This work explores: ${book.subjects.take(5).join(', ').toLowerCase()}${book.subjects.length > 5 ? ', and more' : ''}.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalContext(Book book) {
    if (book.copyright == true) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_edu, size: 16, color: Colors.amber[700]),
              const SizedBox(width: 6),
              Text(
                'Cultural Heritage',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'As a public domain work, this book represents part of our shared cultural heritage. Originally published in an era before modern copyright restrictions, it now belongs to humanity and can be freely shared, studied, and enjoyed by all.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.amber[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationInfo(Book book) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  LocalizationService.instance.translate(
                    AppStrings.bookDetailPublicationInformation,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Book ID', '#${book.id}', Icons.tag),
            const SizedBox(height: 12),
            _buildInfoRow('Media Type', book.mediaType, Icons.category),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Downloads',
              '${book.downloadCount} times',
              Icons.download,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Copyright Status',
              book.copyright == true ? 'Copyrighted' : 'Public Domain',
              book.copyright == true ? Icons.copyright : Icons.public,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection(Book book) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, size: 20, color: Colors.purple[700]),
                const SizedBox(width: 8),
                Text(
                  LocalizationService.instance.translate(
                    AppStrings.bookDetailLanguages,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.languages.map((language) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade100, Colors.purple.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.translate,
                        size: 14,
                        color: Colors.purple[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getLanguageName(language),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.purple[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    // Map common language codes to full names
    const languageMap = {
      'en': 'English',
      'fr': 'French',
      'de': 'German',
      'es': 'Spanish',
      'it': 'Italian',
      'pt': 'Portuguese',
      'nl': 'Dutch',
      'ru': 'Russian',
      'ja': 'Japanese',
      'zh': 'Chinese',
      'ar': 'Arabic',
      'hi': 'Hindi',
      'ko': 'Korean',
      'sv': 'Swedish',
      'da': 'Danish',
      'no': 'Norwegian',
      'fi': 'Finnish',
      'pl': 'Polish',
      'cs': 'Czech',
      'hu': 'Hungarian',
    };

    return languageMap[languageCode.toLowerCase()] ??
        languageCode.toUpperCase();
  }

  Widget _buildCategoriesSection(Book book) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, size: 20, color: Colors.teal[700]),
                const SizedBox(width: 8),
                Text(
                  'Categories & Subjects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (book.subjects.isNotEmpty) ...[
              Text(
                'Subjects',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: book.subjects.map((subject) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.teal.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      subject,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.teal[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (book.bookshelves.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Bookshelves',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: book.bookshelves.map((bookshelf) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade100, Colors.indigo.shade50],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.indigo.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.collections_bookmark,
                          size: 12,
                          color: Colors.indigo[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          bookshelf,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.indigo[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            if (book.subjects.isEmpty && book.bookshelves.isEmpty)
              Text(
                'No categories available for this book.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableFormats(Book book) {
    final availableFormats = book.formats.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    if (availableFormats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.file_download, size: 20, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  LocalizationService.instance.translate(
                    AppStrings.bookDetailAvailableFormats,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: availableFormats.map((format) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildFormatRow(format.key, format.value),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _buildFormatRecommendation(),
          ],
        ),
      ),
    );
  }

  IconData _getFormatIcon(String formatKey) {
    if (formatKey.contains('pdf')) return Icons.picture_as_pdf;
    if (formatKey.contains('epub')) return Icons.menu_book;
    if (formatKey.contains('kindle')) return Icons.import_contacts;
    if (formatKey.contains('txt') || formatKey.contains('text')) {
      return Icons.text_snippet;
    }
    if (formatKey.contains('html')) return Icons.web;
    if (formatKey.contains('xml')) return Icons.code;
    if (formatKey.contains('image')) return Icons.image;
    if (formatKey.contains('audio')) return Icons.audiotrack;
    return Icons.description;
  }

  String _getFormatName(String formatKey) {
    if (formatKey.contains('pdf')) return 'PDF';
    if (formatKey.contains('epub')) return 'EPUB';
    if (formatKey.contains('kindle')) return 'Kindle';
    if (formatKey.contains('txt') || formatKey.contains('text/plain')) {
      return 'Text';
    }
    if (formatKey.contains('html')) return 'HTML';
    if (formatKey.contains('xml')) return 'XML';
    if (formatKey.contains('image/jpeg')) return 'Cover Image';
    if (formatKey.contains('audio')) return 'Audio';

    // Clean up format key for display
    String cleanKey = formatKey
        .replaceAll('application/', '')
        .replaceAll('text/', '');
    cleanKey = cleanKey.split(';').first; // Remove charset info
    return cleanKey.toUpperCase();
  }

  Widget _buildFormatRow(String formatKey, String url) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(_getFormatIcon(formatKey), size: 20, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormatName(formatKey),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  _getFormatDescription(formatKey),
                  style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Available',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormatDescription(String formatKey) {
    Map<String, String> descriptions = {
      'text/html': 'Web-readable format, perfect for online reading',
      'application/epub+zip': 'E-book format compatible with most e-readers',
      'text/plain': 'Simple text format, lightweight and universal',
      'application/rdf+xml': 'Metadata format for digital libraries',
      'image/jpeg': 'Book cover image for visual identification',
      'application/x-mobipocket-ebook': 'Kindle-compatible e-book format',
      'application/pdf': 'Portable document format for universal access',
    };

    return descriptions[formatKey] ?? 'Available in this digital format';
  }

  Widget _buildFormatRecommendation() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: Colors.green[700]),
              const SizedBox(width: 6),
              Text(
                'Format Recommendations',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'For the best reading experience: EPUB for e-readers, HTML for web browsers, or PDF for printing. All formats are free to download and use.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingStatistics(Book book) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, size: 20, color: Colors.purple[700]),
                const SizedBox(width: 8),
                Text(
                  LocalizationService.instance.translate(
                    AppStrings.bookDetailReadingStatistics,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatisticCard(
              LocalizationService.instance.translate(
                AppStrings.bookDetailTotalDownloads,
              ),
              _formatNumber(book.downloadCount),
              Icons.download,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildStatisticCard(
              'Popularity Rank',
              _getPopularityRank(book.downloadCount),
              Icons.trending_up,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildStatisticCard(
              'Available Formats',
              '${book.formats.length}',
              Icons.file_copy,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildStatisticCard(
              'Languages',
              '${book.languages.length}',
              Icons.language,
              Colors.purple,
            ),
            const SizedBox(height: 16),
            _buildReadingTimeEstimate(book),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPopularityRank(int downloadCount) {
    if (downloadCount > 50000) return 'Extremely Popular';
    if (downloadCount > 20000) return 'Very Popular';
    if (downloadCount > 10000) return 'Popular';
    if (downloadCount > 5000) return 'Well-liked';
    if (downloadCount > 1000) return 'Moderately Popular';
    return 'Growing Audience';
  }

  Widget _buildReadingTimeEstimate(Book book) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.indigo[700]),
              const SizedBox(width: 6),
              Text(
                'Reading Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getReadingInfo(book),
            style: TextStyle(
              fontSize: 13,
              color: Colors.indigo[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getReadingInfo(Book book) {
    // Estimate based on subjects and typical book lengths
    String timeEstimate = 'Estimated reading time: ';

    if (book.subjects.any((s) => s.toLowerCase().contains('poetry'))) {
      timeEstimate += '2-4 hours (poetry collection)';
    } else if (book.subjects.any((s) => s.toLowerCase().contains('short'))) {
      timeEstimate += '1-3 hours (short work)';
    } else if (book.subjects.any(
      (s) =>
          s.toLowerCase().contains('novel') ||
          s.toLowerCase().contains('fiction'),
    )) {
      timeEstimate += '6-12 hours (novel)';
    } else {
      timeEstimate += '3-8 hours (typical length)';
    }

    timeEstimate +=
        '. Available in multiple formats for your preferred reading experience.';
    return timeEstimate;
  }

  Widget _buildBookmarkFAB() {
    return Obx(() {
      return FloatingActionButton(
        onPressed: () {
          controller.toggleBookmark(
            onSuccess: (message) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
            },
            onError: (message) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
            },
          );
        },
        backgroundColor: controller.isBookmarkedRx.value
            ? Colors.red
            : Colors.green,
        foregroundColor: Colors.white,
        child: Icon(
          controller.isBookmarkedRx.value
              ? Icons.bookmark_remove
              : Icons.bookmark_add,
          size: 24,
        ),
      );
    });
  }
}
