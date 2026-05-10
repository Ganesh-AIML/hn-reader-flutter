import 'package:equatable/equatable.dart';
import '../../../domain/entities/comment.dart';
import '../../../domain/entities/story.dart';

abstract class DetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final Story story;
  final List<Comment> comments;

  DetailLoaded({required this.story, required this.comments});

  @override
  List<Object?> get props => [story, comments];
}

class DetailError extends DetailState {
  final String message;
  DetailError(this.message);

  @override
  List<Object?> get props => [message];
}