import 'dart:ui';

import 'package:flashcards/features/game/pages/game_page.dart';
import 'package:flashcards/features/sets/models/set_actions.dart';
import 'package:flutter/material.dart';

import '../models/accessibility.dart';

class SetList extends StatelessWidget {
  final Accessibility accessibility;
  const SetList({super.key, required this.accessibility});

  @override
  Widget build(BuildContext context) {
    List<String> privateSets = ["Biology", "Physics"];
    List<String> publicSets = ["Math", "Math 2", "Psychology"];
    return _buildSetList(
        accessibility == Accessibility.private ? privateSets : publicSets,
        context);
  }

  Widget _buildDeleteAlert(String set) {
    Widget cancelButton = Builder(builder: (context) {
      return TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    });
    Widget deleteButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        //TODO: Delete set
      },
    );

    return AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Do you really want to delete set $set? "),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
  }

  ListView _buildSetList(List<String> sets, BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, index) => Divider(),
        itemCount: sets.length,
        itemBuilder: (_, index) {
          final deleteAlert = _buildDeleteAlert(sets[index]);
          return Card(
            child: ListTile(
              title: Text(sets[index]),
              trailing: PopupMenuButton<SetAction>(
                onSelected: (value) {
                  switch (value) {
                    case SetAction.delete:
                      showDialog(context: context, builder: (_) => deleteAlert);
                      break;
                    case SetAction.edit:
                      // TODO: Handle this case.
                      break;
                    case SetAction.info:
                      // TODO: Handle this case.
                      break;
                    case SetAction.statistics:
                      // TODO: Handle this case.
                      break;
                  }
                },
                itemBuilder: (_) => <PopupMenuEntry<SetAction>>[
                  _buildPopUpItem(SetAction.statistics, Icons.auto_graph,
                      "Show statistics"),
                  _buildPopUpItem(SetAction.edit, Icons.edit, "Edit set"),
                  _buildPopUpItem(SetAction.info, Icons.info, "Show info"),
                  _buildPopUpItem(SetAction.delete, Icons.delete, "Delete set"),
                ],
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GamePage()),
              ),
            ),
          );
        });
  }

  PopupMenuItem<SetAction> _buildPopUpItem(
      SetAction setActions, IconData iconData, String itemText) {
    return PopupMenuItem<SetAction>(
        value: setActions,
        child: ListTile(leading: Icon(iconData), title: Text(itemText)));
  }
}
