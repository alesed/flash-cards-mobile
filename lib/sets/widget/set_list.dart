import 'package:flashcards/game/widget/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SetList extends StatelessWidget {
  const SetList({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> sets = ["Biology", "Physics"];
    return ListView.separated(
        separatorBuilder: (_, index) => Divider(),
        itemCount: sets.length,
        itemBuilder: (_, index) => Card(
              child: ListTile(
                title: Text(sets[index]),
                trailing: //TODO should be here PopupMenuButton or multiple different buttons for edit, delete etc.?
                    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GamePage()),
                ),
              ),
            ));
  }
}
