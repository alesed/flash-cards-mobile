import 'package:flashcards/features/game/pages/game_page.dart';
import 'package:flashcards/locator.dart';
import 'package:flashcards/features/sets/pages/sets_page.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocator();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SetsPage(), //RegisterPage(),
      ),
    );
  }
}
