import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/entities/event_entity.dart';

class EventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.poster != null)
              Hero(
                tag: 'event_poster_${event.id}',
                child: CachedNetworkImage(
                  imageUrl: event.poster!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.title, style: Theme.of(context).textTheme.titleLarge),
                        if (onDelete == null)
                          Text('Rating: ${event.rating ?? 'N/A'} ★', style: Theme.of(context).textTheme.titleMedium),
                        if (onDelete != null)
                          Text('Fecha: ${event.date ?? 'N/A'}', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}