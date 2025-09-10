import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/database/database_helper.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    super.poster,
    super.location,
    super.date,
    super.type,
    super.category,
    super.website,
    super.description,
    super.rating,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      poster: json['poster'],
      location: json['location'],
      date: json['date'],
      type: json['type'],
      category: json['category'],
      website: json['website'],
      description: json['description'],
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  factory EventModel.fromDb(Map<String, dynamic> map) {
    return EventModel(
      id: map[DatabaseHelper.columnId],
      title: map[DatabaseHelper.columnTitle],
      poster: map[DatabaseHelper.columnPoster],
      location: map[DatabaseHelper.columnLocation],
      date: map[DatabaseHelper.columnDate],
      type: map[DatabaseHelper.columnType],
      category: map[DatabaseHelper.columnCategory],
      website: map[DatabaseHelper.columnWebsite],
      description: map[DatabaseHelper.columnDescription],
      rating: map[DatabaseHelper.columnRating],
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnPoster: poster,
      DatabaseHelper.columnLocation: location,
      DatabaseHelper.columnDate: date,
      DatabaseHelper.columnType: type,
      DatabaseHelper.columnCategory: category,
      DatabaseHelper.columnWebsite: website,
      DatabaseHelper.columnDescription: description,
      DatabaseHelper.columnRating: rating,
    };
  }
}