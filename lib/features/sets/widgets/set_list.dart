import 'package:flashcards/features/game/pages/game_page.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/set_actions.dart';
import 'package:flashcards/features/sets/models/sets_filter.dart';
import 'package:flashcards/features/sets/pages/set_info_page.dart';
import 'package:flashcards/features/sets/pages/sets_upsert_page.dart';
import 'package:flashcards/features/sets/services/set_upsert_service.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';

class SetList extends StatelessWidget {
  final _setsService = getIt<SetUpsertService>();
  final _setsManagerService = getIt<SetsManagerService>();

  final SetsFilter setsFilter;
  SetList({super.key, required this.setsFilter});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _setsManagerService.getFilteredSetsStream(setsFilter),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Err: ${snapshot.error.toString()}");
        }
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final setList = snapshot.data!;
        return ListView.separated(
          separatorBuilder: (_, index) => Divider(),
          itemCount: setList.length,
          itemBuilder: (_, index) {
            final deleteAlert = _buildDeleteAlert(setList[index]);
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
                            cardSetIdToModify: setList[index].id,
                          ),
                        ));
                        // TODO: Handle this case.
                        break;
                      case SetAction.info:
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SetInfoPage(
                                  setToShow: setList[index],
                                )));
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
                    _buildPopUpItem(SetAction.info, Icons.info, "Show info"),
                    if (setList[index].ownerId == 1) ...[
                      //TODO: add real owner id
                      _buildPopUpItem(SetAction.edit, Icons.edit, "Edit set"),
                      _buildPopUpItem(
                          SetAction.delete, Icons.delete, "Delete set"),
                    ],
                  ],
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => GamePage(
                            setId: setList[index].id,
                          )),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDeleteAlert(CardSetModel set) {
    Widget cancelButton = Builder(builder: (context) {
      return TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    });
    Widget deleteButton = Builder(builder: (context) {
      return TextButton(
          child: Text("Delete"),
          onPressed: () {
            Navigator.pop(context);
            _setsManagerService.deleteSet(set.id);
            //TODO: better delete UI (show status and error)
          });
    });

    return AlertDialog(
      title: Text("Delete ${set.setName}"),
      content: Text("Do you really want to delete set ${set.setName}? "),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
  }

  PopupMenuItem<SetAction> _buildPopUpItem(
      SetAction setActions, IconData iconData, String itemText) {
    return PopupMenuItem<SetAction>(
        value: setActions,
        child: ListTile(leading: Icon(iconData), title: Text(itemText)));
  }
}
