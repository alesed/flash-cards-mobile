import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/services/sets_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flashcards/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class SetsUpsertPage extends StatefulWidget {
  int? cardSetIdToModify;
  SetsUpsertPage({super.key, this.cardSetIdToModify});

  @override
  State<SetsUpsertPage> createState() => _SetsUpsertPageState();
}

class _SetsUpsertPageState extends State<SetsUpsertPage> {
  Accessibility _accessibilityState = Accessibility.private;
  final setsService = getIt.get<SetsService>();

  @override
  void initState() {
    super.initState();
    if (widget.cardSetIdToModify == null) {
      setsService.createNewSet();
    } else {
      //TODO: load set
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavigationDrawer(),
      appBar: AppBar(
          title: Text(widget.cardSetIdToModify == null
              ? "Create new set"
              : "Update set")),
      body: ListView(children: [
        TextField(
          onSubmitted: (value) {
            setsService.setName = value;
          },
          style: TextStyle(fontSize: 30),
        ),
        _buildAccessibilityChooser(),
        ElevatedButton(
            onPressed: () => setsService.addCard(CardModel(
                id: Uuid().v4(), frontText: "frontText", backText: "backText")),
            child: Text("+")),
        _buildCardList(),
      ]),
    );
  }

  Widget _buildCardList() {
    return StreamBuilder<List<CardModel>>(
      stream: setsService.addedCards,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Err: ${snapshot.error.toString()}");
        }
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final cardList = snapshot.data!;
        return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: cardList.length,
            itemBuilder: (_, index) {
              return _buildCardModifier(cardList[index]);
            });
      },
    );
  }

  Row _buildAccessibilityChooser() {
    return Row(children: [
      Text("Accessibility: "),
      DropdownButton<Accessibility>(
        value: _accessibilityState,
        onChanged: (value) {
          setState(() {
            _accessibilityState = value!;
          });
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
          decoration: InputDecoration(hintText: "Card's front text"),
        ),
        TextField(
          controller: TextEditingController(text: cardModel.backText),
          onChanged: (value) {},
          decoration: InputDecoration(hintText: "Card's back text"),
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
