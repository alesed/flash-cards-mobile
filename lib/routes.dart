import 'package:flashcards/features/auth/pages/auth_page.dart';
import 'package:flashcards/features/auth/pages/login_page.dart';
import 'package:flashcards/features/home/pages/home_page.dart';
import 'package:flashcards/features/sets/pages/sets_page.dart';
import 'package:flashcards/features/sets/pages/sets_upsert_page.dart';
import 'package:flashcards/features/statistics/pages/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return AuthPage();
      },
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
        )
      ],
    ),
  ],
);
