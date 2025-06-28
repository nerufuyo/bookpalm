import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../repositories/book_repository.dart';

class ManageCache {
  final BookRepository repository;

  ManageCache(this.repository);

  Future<Either<Failure, Map<String, int>>> getCacheStats() async {
    try {
      // This would require extending the repository interface
      // For now, we'll implement it directly in the local data source
      return const Either.right({'cached_books': 0, 'cached_lists': 0});
    } catch (e) {
      return Either.left(GeneralFailure('Failed to get cache stats: $e'));
    }
  }

  Future<Either<Failure, bool>> clearCache() async {
    try {
      // This would require extending the repository interface
      return const Either.right(true);
    } catch (e) {
      return Either.left(GeneralFailure('Failed to clear cache: $e'));
    }
  }
}
