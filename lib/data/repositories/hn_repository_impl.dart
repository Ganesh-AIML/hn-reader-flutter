import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/hn_repository.dart';
import '../models/comment_model.dart';
import '../models/story_model.dart';

class HNRepositoryImpl implements HNRepository {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<int>> getTopStoryIds() async {
    try {
      final response = await _dio.get(ApiConstants.topStories);
      return (response.data as List<dynamic>).map((e) => e as int).toList();
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to fetch story IDs');
    }
  }

  @override
  Future<Story> getStory(int id) async {
    try {
      final response = await _dio.get(ApiConstants.item(id));
      return StoryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to fetch story $id');
    }
  }

  @override
  Future<Comment> getComment(int id) async {
    try {
      final response = await _dio.get(ApiConstants.item(id));
      return CommentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Failed to fetch comment $id');
    }
  }
}