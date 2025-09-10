import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/event_list_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/pages/event_detail_page.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/widgets/event_card.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});
  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventListBloc>().add(FetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventListBloc, EventListState>(
        builder: (context, state) {
          if (state is EventListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventListLoaded) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return EventCard(
                  event: event,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => EventDetailPage(event: event),
                    ));
                  },
                );
              },
            );
          }
          if (state is EventListError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No events found'));
        },
      ),
    );
  }
}