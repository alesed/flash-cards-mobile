import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/features/game/pages/game_page.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/set_actions.dart';
import 'package:flashcards/features/sets/models/sets_filter.dart';
import 'package:flashcards/features/sets/pages/set_info_page.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SetList extends StatelessWidget {
  final _setsManagerService = getIt<SetsManagerService>();
  final _authService = getIt<AuthenticationService>();

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
                trailing:
                    _buildPopupMenuButton(context, deleteAlert, setList, index),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GamePage(
                      setId: setList[index].id,
                      setName: setList[index].setName,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  PopupMenuButton<SetAction> _buildPopupMenuButton(BuildContext context,
      Widget deleteAlert, List<CardSetModel> setList, int index) {
    return PopupMenuButton<SetAction>(
      onSelected: (value) {
        switch (value) {
          case SetAction.delete:
            showDialog(context: context, builder: (_) => deleteAlert);
            break;
          case SetAction.edit:
            context.goNamed('set-upsert',
                queryParameters: {'cardSetIdToModify': setList[index].id});
            break;
          case SetAction.info:
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SetInfoPage(
                      setToShow: setList[index],
                    )));
            break;
        }
      },
      itemBuilder: (_) => <PopupMenuEntry<SetAction>>[
        _buildPopUpItem(SetAction.info, Icons.info, "Show info"),
        if (setList[index].ownerId == _authService.currentUser!.uid) ...[
          _buildPopUpItem(SetAction.edit, Icons.edit, "Edit set"),
          _buildPopUpItem(SetAction.delete, Icons.delete, "Delete set"),
        ],
      ],
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
          onPressed: () async {
            Navigator.pop(context);
            await _setsManagerService.deleteSet(set.id);
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
