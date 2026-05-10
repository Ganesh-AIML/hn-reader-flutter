import '../entities/comment.dart';
import '../repositories/hn_repository.dart';

class GetComments {
  final HNRepository repository;
  GetComments(this.repository);

  Future<List<Comment>> call(List<int> ids) async {
    final comments = await Future.wait(
      ids.map((id) => repository.getComment(id)),
    );
    return comments
        .where((c) => !c.deleted && !c.dead && c.text != null)
        .toList();
  }
}