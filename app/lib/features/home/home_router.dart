import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/views/home_screen.dart';
import 'presentation/view_models/home_view_model.dart';
import '../../../core/di/injection.dart';

final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

final StatefulShellBranch homeBranch = StatefulShellBranch(
  navigatorKey: homeNavigatorKey,
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => sl<HomeViewModel>(),
        child: const HomePage(),
      ),
    ),
  ],
);
