import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/constants/api_constants.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/services/auth_manager.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/models/comment_model.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents();
  Future<List<CommentModel>> getComments(int eventId);
  Future<void> postComment(int eventId, String comment, int rating);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final http.Client client;
  final AuthManager authManager;

  EventRemoteDataSourceImpl({required this.client, required this.authManager});

  @override
  Future<List<EventModel>> getEvents() async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}/events'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => EventModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Future<List<CommentModel>> getComments(int eventId) async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}/comments/$eventId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => CommentModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<void> postComment(int eventId, String comment, int rating) async {
    final token = authManager.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'eventId': eventId,
        'comment': comment,
        'rating': rating,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post comment');
    }
  }
}