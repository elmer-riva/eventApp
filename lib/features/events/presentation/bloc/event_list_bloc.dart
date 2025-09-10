import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/utils/resource.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/repositories/event_repository.dart';

// event
class FetchEvents extends Equatable {
  @override
  List<Object> get props => [];
}

//state
abstract class EventListState extends Equatable {
  const EventListState();
  @override
  List<Object> get props => [];
}

class EventListInitial extends EventListState {}
class EventListLoading extends EventListState {}
class EventListLoaded extends EventListState {
  final List<EventEntity> events;
  const EventListLoaded(this.events);
  @override
  List<Object> get props => [events];
}
class EventListError extends EventListState {
  final String message;
  const EventListError(this.message);
  @override
  List<Object> get props => [message];
}

//bloc
class EventListBloc extends Bloc<FetchEvents, EventListState> {
  final EventRepository eventRepository;
  EventListBloc({required this.eventRepository}) : super(EventListInitial()) {
    on<FetchEvents>((event, emit) async {
      emit(EventListLoading());
      final result = await eventRepository.getEvents();
      print('Event IDs: ${result.data?.map((e) => e.id).join(', ')}');
      if (result is Success) {
        emit(EventListLoaded(result.data!));
      } else {
        emit(EventListError(result.message!));
      }
    });
  }
}