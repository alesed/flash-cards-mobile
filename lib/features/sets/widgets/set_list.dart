import 'dart:ui';

import 'package:flashcards/features/game/pages/game_page.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/set_actions.dart';
import 'package:flashcards/features/sets/models/sets_filter.dart';
import 'package:flashcards/features/sets/pages/sets_upsert_page.dart';
import 'package:flashcards/features/sets/services/sets_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';

import '../models/accessibility.dart';

class SetList extends StatelessWidget {
  final _setsService = getIt<SetsService>();

  final SetsFilter setsFilter;
  SetList({super.key, required this.setsFilter});

  @override
  Widget build(BuildContext context) {
    return _buildSetList(context);
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

  Widget _buildSetList(BuildContext context) {
    return StreamBuilder(
        stream: _setsService.getFilteredSetsStream(setsFilter),
        builder: (context, snapshot) {
          final setList = snapshot.data!;
          return ListView.separated(
              separatorBuilder: (_, index) => Divider(),
              itemCount: setList.length,
              itemBuilder: (_, index) {
                final deleteAlert = _buildDeleteAlert(setList[index].setName);
                return Card(
                  child: ListTile(
                    title: Text(setList[index].setName),
                    trailing: PopupMenuButton<SetAction>(
                      onSelected: (value) {
                        switch (value) {
                          case SetAction.delete:
                            showDialog(
                                context: context, builder: (_) => deleteAlert);
                            break;
                          case SetAction.edit:
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SetsUpsertPage(
                                cardSetIdToModify: "1",
                              ),
                            ));
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
                        _buildPopUpItem(
                            SetAction.info, Icons.info, "Show info"),
                        if (setList[index].ownerId == 5) ...[
                          //TODO: add real owner id
                          _buildPopUpItem(
                              SetAction.edit, Icons.edit, "Edit set"),
                          _buildPopUpItem(
                              SetAction.delete, Icons.delete, "Delete set"),
                        ],
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GamePage()),
                    ),
                  ),
                );
              });
        });
  }

  PopupMenuItem<SetAction> _buildPopUpItem(
      SetAction setActions, IconData iconData, String itemText) {
    return PopupMenuItem<SetAction>(
        value: setActions,
        child: ListTile(leading: Icon(iconData), title: Text(itemText)));
  }
}
