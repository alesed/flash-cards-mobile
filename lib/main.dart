import 'package:flashcards/game/widget/game_page.dart';
import 'package:flashcards/locator.dart';
import 'package:flashcards/auth/widgets/register_page.dart';
import 'package:flashcards/sets/widget/sets_page.dart';
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
        body: GamePage(), //RegisterPage(),
      ),
    );
  }
}
