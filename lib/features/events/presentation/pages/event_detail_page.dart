import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/di/injection_container.dart' as di;
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/event_detail_bloc.dart';

class EventDetailPage extends StatelessWidget {
  final EventEntity event;
  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<EventDetailBloc>()..add(LoadEventDetails(event.id)),
      child: Scaffold(
        appBar: AppBar(title: Text(event.title)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.poster != null)
                CachedNetworkImage(
                  imageUrl: event.poster!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(event.title, style: Theme.of(context).textTheme.headlineSmall)),
                        BlocBuilder<EventDetailBloc, EventDetailState>(
                          builder: (context, state) {
                            return IconButton(
                              icon: Icon(state.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                              onPressed: () => context.read<EventDetailBloc>().add(ToggleFavorite(event)),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.location_on, event.location),
                    _buildDetailRow(Icons.calendar_today, event.date),
                    _buildDetailRow(Icons.local_activity, event.type),
                    _buildDetailRow(Icons.category, event.category),
                    _buildDetailRow(Icons.link, event.website),
                    _buildDetailRow(Icons.star, 'Rating: ${event.rating}'),
                    const SizedBox(height: 16),
                    Text(event.description ?? '', style: Theme.of(context).textTheme.bodyMedium),
                    const Divider(height: 32),
                    Text('Comentarios', style: Theme.of(context).textTheme.headlineSmall),
                    _buildCommentSection(),
                    const Divider(height: 32),
                    _buildAddCommentSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(children: [Icon(icon, size: 16), const SizedBox(width: 8), Expanded(child: Text(text))]),
    );
  }

  Widget _buildCommentSection() {
    return BlocBuilder<EventDetailBloc, EventDetailState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());
        if (state.comments.isEmpty) return const Text('No hay comentarios aún.');
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.comments.length,
          itemBuilder: (context, index) {
            final comment = state.comments[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text('${comment.userFirstName} ${comment.userLastName}'),
                subtitle: Text(comment.comment),
                trailing: Text('${comment.rating} ★'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddCommentSection() {
    final commentController = TextEditingController();
    double rating = 3;
    return BlocConsumer<EventDetailBloc, EventDetailState>(
      listener: (context, state) {
        if (state.commentPostSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comentario publicado')));
          commentController.clear();
        }
        if (state.error != null && !state.commentPostSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Añadir un comentario', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (newRating) => rating = newRating,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tu opinión...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  context.read<EventDetailBloc>().add(PostComment(
                    eventId: event.id,
                    comment: commentController.text,
                    rating: rating.toInt(),
                  ));
                }
              },
              child: const Text('Enviar Comentario'),
            ),
            const SizedBox(height: 50)
          ],
        );
      },
    );
  }
}