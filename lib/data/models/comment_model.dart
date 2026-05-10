import '../../domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    super.by,
    super.text,
    required super.kids,
    required super.deleted,
    required super.dead,
    super.parent,
    super.time,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      by: json['by'] as String?,
      text: json['text'] as String?,
      kids: (json['kids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      deleted: json['deleted'] as bool? ?? false,
      dead: json['dead'] as bool? ?? false,
      parent: json['parent'] as int?,
      time: json['time'] as int?,
    );
  }
}