import 'package:equatable/equatable.dart';
import '../../../domain/entities/story.dart';

abstract class StoriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<Story> stories;
  final bool hasMore;

  StoriesLoaded({required this.stories, this.hasMore = true});

  StoriesLoaded copyWith({List<Story>? stories, bool? hasMore}) {
    return StoriesLoaded(
      stories: stories ?? this.stories,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [stories, hasMore];
}

class StoriesError extends StoriesState {
  final String message;
  StoriesError(this.message);

  @override
  List<Object?> get props => [message];
}