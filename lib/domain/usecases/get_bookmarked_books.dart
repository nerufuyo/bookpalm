import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/usecases/usecase.dart';

class GetBookmarkedBooks implements UseCase<List<Book>, NoParams> {
  final BookRepository repository;

  GetBookmarkedBooks(this.repository);

  @override
  Future<Either<Failure, List<Book>>> call(NoParams params) async {
    return await repository.getBookmarkedBooks();
  }
}
