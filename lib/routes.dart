import 'package:flashcards/features/auth/pages/login_page.dart';
import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/features/home/pages/home_page.dart';
import 'package:flashcards/features/sets/pages/sets_page.dart';
import 'package:flashcards/features/sets/pages/sets_upsert_page.dart';
import 'package:flashcards/features/statistics/pages/statistics_page.dart';
import 'package:flashcards/helpers/go_router_refresh_stream.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  refreshListenable:
      GoRouterRefreshStream(getIt.get<AuthenticationService>().authState),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) {
        final bool userAuthenticated =
            getIt.get<AuthenticationService>().currentUser != null;
        final bool onLoginPage = state.location == '/';

        if (!userAuthenticated && !onLoginPage) {
          return '/login';
        }
        if (userAuthenticated && onLoginPage) {
          return '/home';
        }
        return null;
      },
      builder: (context, state) => LoginPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) => HomePage(),
        ),
        GoRoute(
          path: 'statistics',
          builder: (context, state) => StatisticsPage(),
        ),
        GoRoute(
          path: 'sets',
          builder: (context, state) => SetsPage(),
        ),
        GoRoute(
          name: 'set-upsert',
          path: 'set-upsert',
          builder: (context, state) => SetsUpsertPage(
            cardSetIdToModify: state.queryParameters['cardSetIdToModify'],
          ),
        ),
      ],
    ),
  ],
);
