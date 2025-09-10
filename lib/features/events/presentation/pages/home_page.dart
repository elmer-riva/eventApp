import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/domain/repositories/auth_repository.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/presentation/pages/login_page.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/favorites_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/home_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/di/injection_container.dart' as di;
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/pages/event_list_page.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/pages/favorites_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [const EventListPage(), const FavoritesPage()];
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventApp'),
        backgroundColor: Colors.grey[850],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await di.sl<AuthRepository>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
          )
        ],
      ),
      body: BlocBuilder<HomeBloc, int>(
        builder: (context, state) => pages[state],
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state,
            onTap: (index) {
              if (index == 1) {
                context.read<FavoritesBloc>().add(FetchFavorites());
              }
              context.read<HomeBloc>().add(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
            ],
          );
        },
      ),
    );
  }
}