import 'package:flashcards/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ScaffoldTemplate extends StatelessWidget {
  Widget? Function() builder;
  String title;
  List<Widget>? actions;
  ScaffoldTemplate({
    super.key,
    required this.builder,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: builder(),
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: actions,
      ),
      drawer: CustomNavigationDrawer(),
    );
  }
}
