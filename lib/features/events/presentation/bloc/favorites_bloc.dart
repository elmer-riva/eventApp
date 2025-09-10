import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/utils/resource.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/repositories/event_repository.dart';

//events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object> get props => [];
}
class FetchFavorites extends FavoritesEvent {}
class RemoveFavorite extends FavoritesEvent {
  final int eventId;
  const RemoveFavorite(this.eventId);
}

// states
abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}
class FavoritesInitial extends FavoritesState {}
class FavoritesLoading extends FavoritesState {}
class FavoritesLoaded extends FavoritesState {
  final List<EventEntity> favorites;
  const FavoritesLoaded(this.favorites);
}
class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}

// Bloc
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final EventRepository eventRepository;
  FavoritesBloc({required this.eventRepository}) : super(FavoritesInitial()) {
    on<FetchFavorites>((event, emit) async {
      emit(FavoritesLoading());
      final result = await eventRepository.getFavorites();
      if (result is Success) {
        emit(FavoritesLoaded(result.data!));
      } else {
        emit(FavoritesError(result.message!));
      }
    });
    on<RemoveFavorite>((event, emit) async {
      await eventRepository.deleteFavorite(event.eventId);
      add(FetchFavorites());
    });
  }
}