import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/usecases/usecase.dart';

class GetBookById implements UseCase<Book, int> {
  final BookRepository repository;

  GetBookById(this.repository);

  @override
  Future<Either<Failure, Book>> call(int bookId) async {
    return await repository.getBookById(bookId);
  }
}
