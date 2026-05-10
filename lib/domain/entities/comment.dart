import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int id;
  final String? by;
  final String? text;
  final List<int> kids;
  final bool deleted;
  final bool dead;
  final int? parent;
  final int? time;

  const Comment({
    required this.id,
    this.by,
    this.text,
    required this.kids,
    required this.deleted,
    required this.dead,
    this.parent,
    this.time,
  });

  @override
  List<Object?> get props => [id, by, text, kids, deleted, dead];
}