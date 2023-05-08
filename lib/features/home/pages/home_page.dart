import 'package:flashcards/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomNavigationDrawer(),
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Let's learn some new things!"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go('/sets');
                },
                child: Text("Flashcards"),
              ),
            ],
          ),
        ));
  }
}
