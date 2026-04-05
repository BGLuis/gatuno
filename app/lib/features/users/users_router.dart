import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/views/me_screen.dart';
import 'presentation/view_models/me_view_model.dart';
import '../../../core/di/injection.dart';

final GlobalKey<NavigatorState> profileNavigatorKey =
    GlobalKey<NavigatorState>();

final StatefulShellBranch profileBranch = StatefulShellBranch(
  navigatorKey: profileNavigatorKey,
  routes: [
    GoRoute(
      path: '/users/me',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => sl<MeViewModel>(),
        child: const MePage(),
      ),
    ),
  ],
);
