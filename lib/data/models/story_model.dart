import '../../domain/entities/story.dart';

class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.title,
    super.url,
    required super.by,
    required super.score,
    required super.time,
    required super.descendants,
    required super.kids,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '[no title]',
      url: json['url'] as String?,
      by: json['by'] as String? ?? '[deleted]',
      score: json['score'] as int? ?? 0,
      time: json['time'] as int? ?? 0,
      descendants: json['descendants'] as int? ?? 0,
      kids: (json['kids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
}