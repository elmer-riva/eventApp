import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/di/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/domain/repositories/auth_repository.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/presentation/bloc/login_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/presentation/pages/login_page.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/event_detail_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/event_list_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/favorites_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/home_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<LoginBloc>()),
        BlocProvider(create: (_) => di.sl<HomeBloc>()),
        BlocProvider(create: (_) => di.sl<EventListBloc>()),
        BlocProvider(create: (_) => di.sl<FavoritesBloc>()),
        BlocProvider(create: (_) => di.sl<EventDetailBloc>()),
      ],
      child: MaterialApp(
        title: 'EventApp',
        theme: ThemeData.dark(),
        home: FutureBuilder<bool>(
          future: di.sl<AuthRepository>().isAuthenticated(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData && snapshot.data == true) {
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}