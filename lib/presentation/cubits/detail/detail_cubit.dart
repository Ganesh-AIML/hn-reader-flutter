import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_comments.dart';
import '../../../domain/usecases/get_story_detail.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GetStoryDetail getStoryDetail;
  final GetComments getComments;

  DetailCubit({required this.getStoryDetail, required this.getComments})
      : super(DetailInitial());

  Future<void> fetchDetail(int id, List<int> kids) async {
    emit(DetailLoading());
    try {
      final story = await getStoryDetail(id);
      final comments = await getComments(kids.take(20).toList());
      emit(DetailLoaded(story: story, comments: comments));
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}