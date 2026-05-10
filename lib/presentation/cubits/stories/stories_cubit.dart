import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_top_stories.dart';
import 'stories_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final GetTopStories getTopStories;
  int _currentPage = 0;
  static const int _pageSize = 20;

  StoriesCubit(this.getTopStories) : super(StoriesInitial());

  Future<void> fetchStories() async {
    emit(StoriesLoading());
    _currentPage = 0;
    try {
      final stories = await getTopStories(start: 0, limit: _pageSize);
      emit(StoriesLoaded(stories: stories, hasMore: stories.length == _pageSize));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! StoriesLoaded || !current.hasMore) return;
    _currentPage++;
    try {
      final more = await getTopStories(
        start: _currentPage * _pageSize,
        limit: _pageSize,
      );
      emit(current.copyWith(
        stories: [...current.stories, ...more],
        hasMore: more.length == _pageSize,
      ));
    } catch (_) {}
  }
}