import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flashcards/features/sets/services/sets_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flashcards/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/card_set_model.dart';

const _EMPTY_ERR_MSG = "This field cannot be empty";

class SetsUpsertPage extends StatelessWidget {
  final setsService = getIt.get<SetsService>();
  String? cardSetIdToModify;
  SetsUpsertPage({super.key, this.cardSetIdToModify}) {
    if (cardSetIdToModify == null) {
      setsService.createEmptySet();
    } else {
      setsService.loadSet(cardSetIdToModify!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavigationDrawer(),
      appBar: AppBar(
          title: Text(
              cardSetIdToModify == null ? "Create new set" : "Update set")),
      body: StreamBuilder<CardSetModel>(
          stream: setsService.cardSetStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Err.: ${snapshot.error.toString()}");
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final cardSet = snapshot.data!;
            return ListView(children: [
              _buildNameField(cardSet),
              _buildAccessibilityChooser(cardSet),
              _buildAddCardButton(),
              _buildCardList(cardSet.cardList),
            ]);
          }),
    );
  }

  ElevatedButton _buildAddCardButton() {
    return ElevatedButton(
        onPressed: () => setsService
            .addCard(CardModel(id: Uuid().v4(), frontText: "", backText: "")),
        child: Text("+"));
  }

  TextField _buildNameField(CardSetModel cardSet) {
    return TextField(
      controller: TextEditingController(text: cardSet.setName),
      onSubmitted: (value) {
        setsService.updateCardSet(cardSet.copyWith(setName: value));
      },
      style: TextStyle(fontSize: 30),
      decoration: InputDecoration(
          labelText: "Card set name",
          errorText: cardSet.setName.isEmpty ? _EMPTY_ERR_MSG : null),
    );
  }

  Widget _buildCardList(List<CardModel> cardList) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: cardList.length,
        itemBuilder: (_, index) {
          return _buildCardModifier(cardList[index]);
        });
  }

  Row _buildAccessibilityChooser(CardSetModel cardSet) {
    return Row(children: [
      Text("Accessibility: "),
      DropdownButton<Accessibility>(
        value: cardSet.accessibility,
        onChanged: (value) {
          setsService.updateCardSet(cardSet.copyWith(accessibility: value));
        },
        items: Accessibility.values
            .map<DropdownMenuItem<Accessibility>>(
                (value) => DropdownMenuItem<Accessibility>(
                      value: value,
                      child: Text(value.name),
                    ))
            .toList(),
      )
    ]);
  }

  Card _buildCardModifier(CardModel cardModel) {
    return Card(
        child: Column(
      children: [
        TextField(
          controller: TextEditingController(text: cardModel.frontText),
          onSubmitted: (value) {
            setsService.updateCard(
                cardModel.id, cardModel.copyWith(frontText: value));
          },
          decoration: InputDecoration(
              errorText: cardModel.frontText.isEmpty ? _EMPTY_ERR_MSG : null,
              labelText: "Front text"),
        ),
        TextField(
          controller: TextEditingController(text: cardModel.backText),
          onSubmitted: (value) {
            setsService.updateCard(
                cardModel.id, cardModel.copyWith(backText: value));
          },
          decoration: InputDecoration(
            errorText: cardModel.backText.isEmpty ? _EMPTY_ERR_MSG : null,
            labelText: "Back text",
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setsService.deleteCard(cardModel.id);
          },
          color: Colors.red,
        )
      ],
    ));
  }
}
