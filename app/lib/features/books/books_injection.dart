import 'package:get_it/get_it.dart';
import '../../core/network/dio_client.dart';
import '../users/data/data_sources/user_local_data_source.dart';
import 'data/repositories/books_repository_impl.dart';
import 'domain/repositories/books_repository.dart';
import 'presentation/view_models/books_view_model.dart';

void initBooksInjection(GetIt sl) {
  // Repositories
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(sl<DioClient>()),
  );

  // View Models
  sl.registerFactory<BooksViewModel>(
    () => BooksViewModel(
      repository: sl<BooksRepository>(),
      userStorage: sl<UserStorage>(),
    ),
  );
}
