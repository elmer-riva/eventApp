import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/utils/resource.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/comment_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/repositories/event_repository.dart';

//events
abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();
  @override
  List<Object> get props => [];
}
class LoadEventDetails extends EventDetailEvent {
  final int eventId;
  const LoadEventDetails(this.eventId);
}
class ToggleFavorite extends EventDetailEvent {
  final EventEntity event;
  const ToggleFavorite(this.event);
}
class PostComment extends EventDetailEvent {
  final int eventId;
  final String comment;
  final int rating;
  const PostComment({required this.eventId, required this.comment, required this.rating});
}

// States
class EventDetailState extends Equatable {
  final List<CommentEntity> comments;
  final bool isFavorite;
  final bool isLoading;
  final String? error;
  final bool commentPostSuccess;

  const EventDetailState({
    this.comments = const [],
    this.isFavorite = false,
    this.isLoading = false,
    this.error,
    this.commentPostSuccess = false,
  });

  EventDetailState copyWith({
    List<CommentEntity>? comments,
    bool? isFavorite,
    bool? isLoading,
    String? error,
    bool? commentPostSuccess,
  }) {
    return EventDetailState(
      comments: comments ?? this.comments,
      isFavorite: isFavorite ?? this.isFavorite,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      commentPostSuccess: commentPostSuccess ?? this.commentPostSuccess,
    );
  }

  @override
  List<Object?> get props => [comments, isFavorite, isLoading, error, commentPostSuccess];
}

// Bloc
class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventRepository eventRepository;
  EventDetailBloc({required this.eventRepository}) : super(const EventDetailState()) {
    on<LoadEventDetails>(_onLoadEventDetails);
    on<ToggleFavorite>(_onToggleFavorite);
    on<PostComment>(_onPostComment);
  }

  Future<void> _onLoadEventDetails(LoadEventDetails event, Emitter<EventDetailState> emit) async {
    emit(state.copyWith(isLoading: true));
    final isFav = await eventRepository.isFavorite(event.eventId);
    final commentsResult = await eventRepository.getComments(event.eventId);
    if (commentsResult is Success) {
      emit(state.copyWith(
        comments: commentsResult.data,
        isFavorite: isFav,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        isFavorite: isFav,
        isLoading: false,
        error: commentsResult.message,
      ));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<EventDetailState> emit) async {
    final newFavStatus = !state.isFavorite;
    if (newFavStatus) {
      await eventRepository.saveFavorite(event.event);
    } else {
      await eventRepository.deleteFavorite(event.event.id);
    }
    emit(state.copyWith(isFavorite: newFavStatus));
  }

  Future<void> _onPostComment(PostComment event, Emitter<EventDetailState> emit) async {
    final result = await eventRepository.postComment(event.eventId, event.comment, event.rating);
    if (result is Success) {
      emit(state.copyWith(commentPostSuccess: true));
      add(LoadEventDetails(event.eventId));
    } else {
      emit(state.copyWith(error: result.message, commentPostSuccess: false));
    }
  }
}