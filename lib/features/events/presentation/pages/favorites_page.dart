import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/favorites_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/pages/event_detail_page.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/widgets/event_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('No favorites events found'));
            }
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final event = state.favorites[index];
                return EventCard(
                  event: event,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EventDetailPage(event: event),
                    ));
                  },
                  onDelete: () {
                    context.read<FavoritesBloc>().add(RemoveFavorite(event.id));
                  },
                );
              },
            );
          }
          if (state is FavoritesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}