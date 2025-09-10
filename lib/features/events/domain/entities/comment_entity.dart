import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final String eventId;
  final String userId;
  final String comment;
  final int rating;
  final String userFirstName;
  final String userLastName;

  const CommentEntity({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.comment,
    required this.rating,
    required this.userFirstName,
    required this.userLastName,
  });

  @override
  List<Object?> get props => [id, eventId, userId, comment, rating, userFirstName, userLastName];
}
