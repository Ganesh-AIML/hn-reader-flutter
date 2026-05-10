import '../entities/story.dart';
import '../entities/comment.dart';

abstract class HNRepository {
  Future<List<int>> getTopStoryIds();
  Future<Story> getStory(int id);
  Future<Comment> getComment(int id);
}