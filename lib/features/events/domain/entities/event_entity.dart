import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String title;
  final String? poster;
  final String? location;
  final String? date;
  final String? type;
  final String? category;
  final String? website;
  final String? description;
  final double? rating;

  const EventEntity({
    required this.id,
    required this.title,
    this.poster,
    this.location,
    this.date,
    this.type,
    this.category,
    this.website,
    this.description,
    this.rating,
  });

  @override
  List<Object?> get props => [id, title, poster, location, date, type, category, website, description, rating];
}