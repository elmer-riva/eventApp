import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.eventId,
    required super.userId,
    required super.comment,
    required super.rating,
    required super.userFirstName,
    required super.userLastName,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return CommentModel(
      id: json['date'] ?? DateTime.now().toIso8601String(),
      eventId: (json['eventId'] ?? 0).toString(),
      userId: user['email'] ?? 'unknown_user',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      userFirstName: user['firstName'] ?? 'Usuario',
      userLastName: user['lastName'] ?? 'Anónimo',
    );
  }
}