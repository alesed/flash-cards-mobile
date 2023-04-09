import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards/features/auth/pages/auth_page.dart';
import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/features/sets/pages/sets_page.dart';
import 'package:flashcards/firebase_options.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthenticationService>();

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        body: StreamBuilder<User?>(
            stream: authService.currentUser,
            builder: (context, snapshot) {
              final user = snapshot.data;

              if (user == null) {
                return AuthPage();
              }

              return SetsPage();
            }),
      ),
    );
  }
}
