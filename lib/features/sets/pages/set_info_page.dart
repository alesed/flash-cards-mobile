import 'package:flashcards/features/common/widgets/scaffold_template.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SetInfoPage extends StatelessWidget {
  CardSetModel setToShow;
  SetInfoPage({super.key, required this.setToShow});

  @override
  Widget build(BuildContext context) {
    return ScaffoldTemplate(
      title: "Set info",
      builder: () {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              setToShow.setName,
              style: TextStyle(fontSize: 30),
            ),
            _buildCardList()
          ],
        );
      },
    );
  }

  Widget _buildCardList() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final cardToShow = setToShow.cardList[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(cardToShow.frontText),
              Divider(
                color: Colors.black,
              ),
              Text(cardToShow.backText)
            ]),
          ),
        );
      },
      itemCount: setToShow.cardList.length,
    );
  }
}
