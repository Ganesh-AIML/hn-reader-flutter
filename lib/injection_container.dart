import 'package:get_it/get_it.dart';
import 'data/repositories/hn_repository_impl.dart';
import 'domain/repositories/hn_repository.dart';
import 'domain/usecases/get_comments.dart';
import 'domain/usecases/get_story_detail.dart';
import 'domain/usecases/get_top_stories.dart';
import 'presentation/cubits/detail/detail_cubit.dart';
import 'presentation/cubits/stories/stories_cubit.dart';

final sl = GetIt.instance;

void init() {
  // Repository
  sl.registerLazySingleton<HNRepository>(() => HNRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => GetTopStories(sl()));
  sl.registerLazySingleton(() => GetStoryDetail(sl()));
  sl.registerLazySingleton(() => GetComments(sl()));

  // Cubits — factory so each screen gets fresh instance
  sl.registerFactory(() => StoriesCubit(sl()));
  sl.registerFactory(() => DetailCubit(getStoryDetail: sl(), getComments: sl()));
}