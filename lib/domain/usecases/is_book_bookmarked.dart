import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/usecases/usecase.dart';

class IsBookBookmarked implements UseCase<bool, int> {
  final BookRepository repository;

  IsBookBookmarked(this.repository);

  @override
  Future<Either<Failure, bool>> call(int bookId) async {
    return await repository.isBookmarked(bookId);
  }
}
