import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'presentation/views/books_screen.dart';
import 'presentation/view_models/books_view_model.dart';
import 'presentation/views/book_details_screen.dart';
import 'presentation/view_models/book_details_view_model.dart';
import '../../../core/di/injection.dart';
import '../../../core/router/router_keys.dart';

final GlobalKey<NavigatorState> booksNavigatorKey = GlobalKey<NavigatorState>();

final StatefulShellBranch booksBranch = StatefulShellBranch(
  navigatorKey: booksNavigatorKey,
  routes: [
    GoRoute(
      path: '/books',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => sl<BooksViewModel>(),
        child: const BooksPage(),
      ),
      routes: [
        GoRoute(
          path: ':bookId',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final bookId = state.pathParameters['bookId']!;
            return ChangeNotifierProvider(
              create: (_) => sl<BookDetailsViewModel>(param1: bookId),
              child: const BookDetailsPage(),
            );
          },
        ),
      ],
    ),
  ],
);
