import 'package:flashcards/navigation/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flashcards/sets/model/card.dart' as model;

const _CARD_SIZE = 300.0;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  MatchEngine? _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  bool _cardFrontShowed = true;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _swipeItems.add(SwipeItem(
          content: model.Card(backText: "Back: $i", frontText: "Front: $i"),
          likeAction: () => print("Liked"),
          nopeAction: () => print("disliked")));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Practising \"Biology\""),
        ),
        drawer: CustomNavigationDrawer(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: _CARD_SIZE,
                child: SwipeCards(
                    matchEngine: _matchEngine!,
                    onStackFinished: () {
                      print("finished");
                    },
                    itemBuilder: (_, index) {
                      return Center(
                          child: _buildCard(_cardFrontShowed == true
                              ? _swipeItems[index].content.frontText
                              : _swipeItems[index].content.backText));
                    }),
              ),
              //_buildCard(),
              SizedBox(
                height: 50,
              ),
              _buildButtons(),
            ],
          ),
        ));
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        ElevatedButton(
            onPressed: () {
              _matchEngine?.currentItem?.like();
            },
            child: Text("Yes")),
        Spacer(),
        ElevatedButton(
            onPressed: () {
              _matchEngine?.currentItem?.nope();
            },
            child: Text("No")),
        Spacer(),
      ],
    );
  }

  Widget _buildCard(String cardText) {
    return SizedBox(
      width: _CARD_SIZE,
      height: _CARD_SIZE,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () {
          setState(() {
            _cardFrontShowed = !_cardFrontShowed;
          });
        },
        child: Text(
          cardText,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
