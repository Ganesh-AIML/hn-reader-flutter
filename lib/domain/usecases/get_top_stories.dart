import '../entities/story.dart';
import '../repositories/hn_repository.dart';

class GetTopStories {
  final HNRepository repository;
  GetTopStories(this.repository);

  Future<List<Story>> call({int start = 0, int limit = 20}) async {
    final ids = await repository.getTopStoryIds();
    final slice = ids.skip(start).take(limit).toList();
    final stories = await Future.wait(
      slice.map((id) => repository.getStory(id)),
    );
    return stories;
  }
}