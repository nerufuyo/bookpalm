import '../entities/book_list_response.dart';
import '../repositories/book_repository.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/usecases/usecase.dart';

class GetBooks implements UseCase<BookListResponse, GetBooksParams> {
  final BookRepository repository;

  GetBooks(this.repository);

  @override
  Future<Either<Failure, BookListResponse>> call(GetBooksParams params) async {
    return await repository.getBooks(
      search: params.search,
      languages: params.languages,
      topic: params.topic,
      authorYearStart: params.authorYearStart,
      authorYearEnd: params.authorYearEnd,
      sort: params.sort,
      page: params.page,
    );
  }
}

class GetBooksParams {
  final String? search;
  final List<String>? languages;
  final String? topic;
  final int? authorYearStart;
  final int? authorYearEnd;
  final String? sort;
  final int page;

  const GetBooksParams({
    this.search,
    this.languages,
    this.topic,
    this.authorYearStart,
    this.authorYearEnd,
    this.sort,
    this.page = 1,
  });
}
