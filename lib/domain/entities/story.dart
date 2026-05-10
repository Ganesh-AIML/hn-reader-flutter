import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final int id;
  final String title;
  final String? url;
  final String by;
  final int score;
  final int time;
  final int descendants;
  final List<int> kids;

  const Story({
    required this.id,
    required this.title,
    this.url,
    required this.by,
    required this.score,
    required this.time,
    required this.descendants,
    required this.kids,
  });

  @override
  List<Object?> get props => [id, title, url, by, score, time, descendants, kids];
}