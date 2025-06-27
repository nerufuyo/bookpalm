import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/usecases/usecase.dart';

class BookmarkBook implements UseCase<bool, Book> {
  final BookRepository repository;

  BookmarkBook(this.repository);

  @override
  Future<Either<Failure, bool>> call(Book book) async {
    return await repository.bookmarkBook(book);
  }
}
