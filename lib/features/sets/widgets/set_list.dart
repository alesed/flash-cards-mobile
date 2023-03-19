import 'package:flashcards/features/game/pages/game_page.dart';
import 'package:flutter/material.dart';

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
                trailing: // TODO: should be PopupMenuButton
                    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GamePage()),
                ),
              ),
            ));
  }
}
