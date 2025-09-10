import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/utils/resource.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/datasources/event_local_data_source.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/datasources/event_remote_data_source.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/models/event_model.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/comment_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final EventLocalDataSource localDataSource;

  EventRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Resource<List<EventEntity>>> getEvents() async {
    try {
      final events = await remoteDataSource.getEvents();
      return Success(events);
    } catch(e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<List<CommentEntity>>> getComments(int eventId) async {
    try {
      final comments = await remoteDataSource.getComments(eventId);
      return Success(comments);
    } catch(e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<void>> postComment(int eventId, String comment, int rating) async {
    try {
      await remoteDataSource.postComment(eventId, comment, rating);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<void> deleteFavorite(int eventId) async {
    await localDataSource.deleteFavorite(eventId);
  }

  @override
  Future<Resource<List<EventEntity>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Success(favorites);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<bool> isFavorite(int eventId) async {
    return await localDataSource.isFavorite(eventId);
  }

  @override
  Future<void> saveFavorite(EventEntity event) async {
    await localDataSource.saveFavorite(EventModel(
      id: event.id,
      title: event.title,
      poster: event.poster,
      location: event.location,
      date: event.date,
      type: event.type,
      category: event.category,
      website: event.website,
      description: event.description,
      rating: event.rating,
    ));
  }
}