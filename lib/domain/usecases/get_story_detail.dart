import '../entities/story.dart';
import '../repositories/hn_repository.dart';

class GetStoryDetail {
  final HNRepository repository;
  GetStoryDetail(this.repository);

  Future<Story> call(int id) => repository.getStory(id);
}