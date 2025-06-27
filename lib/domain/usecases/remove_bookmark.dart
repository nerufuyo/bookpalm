import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/usecases/usecase.dart';

class RemoveBookmark implements UseCase<bool, int> {
  final BookRepository repository;

  RemoveBookmark(this.repository);

  @override
  Future<Either<Failure, bool>> call(int bookId) async {
    return await repository.removeBookmark(bookId);
  }
}
