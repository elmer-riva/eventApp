import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/utils/resource.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/comment_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<Resource<List<EventEntity>>> getEvents();
  Future<Resource<List<CommentEntity>>> getComments(int eventId);
  Future<Resource<void>> postComment(int eventId, String comment, int rating);
  Future<Resource<List<EventEntity>>> getFavorites();
  Future<void> saveFavorite(EventEntity event);
  Future<void> deleteFavorite(int eventId);
  Future<bool> isFavorite(int eventId);
}