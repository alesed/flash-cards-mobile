import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SetsUpsertPage extends StatefulWidget {
  CardSetModel? cardSetToModify;
  SetsUpsertPage({super.key, this.cardSetToModify});

  @override
  State<SetsUpsertPage> createState() => _SetsUpsertPageState();
}

class _SetsUpsertPageState extends State<SetsUpsertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavigationDrawer(),
      appBar: AppBar(
          title: Text(widget.cardSetToModify == null
              ? "Create new set"
              : "Update set")),
      body: ListView(children: [
        Card(child: TextField()),
        ListTile(
          title: Text("asdf"),
        ),
        ElevatedButton(onPressed: () => print("clicked"), child: Text("+")),
      ]),
    );
  }
}
