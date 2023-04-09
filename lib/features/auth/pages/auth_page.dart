import 'package:flashcards/features/auth/pages/login_page.dart';
import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/features/home/pages/home_page.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthenticationService>();

    return StreamBuilder(
      stream: authService.authState,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
