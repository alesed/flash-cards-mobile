import 'package:flashcards/features/game/services/game_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:uuid/uuid.dart';
import '../../sets/models/card_model.dart' as model;
import '../../../widgets/custom_navigation_drawer.dart';
import '../../sets/models/card_model.dart';

const _CARD_SIZE = 300.0;

class GamePage extends StatefulWidget {
  final String setId;
  const GamePage({
    super.key,
    required this.setId,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _gameService = getIt.get<GameService>();

  MatchEngine? _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  bool _cardFrontShowed = true;
  @override
  void initState() {
    super.initState();
    _gameService.newGame(widget.setId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Practising \"Biology\""),
        ),
        drawer: CustomNavigationDrawer(),
        body: StreamBuilder<List<CardModel>>(
            stream: _gameService.restingCardsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Err: ${snapshot.error.toString()}");
              }
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final cardList = snapshot.data!;
              for (final card in cardList) {
                _swipeItems.add(SwipeItem(
                    content: card,
                    likeAction: () => _gameService.likeCard(card.id),
                    nopeAction: () => _gameService.dislikeCard(card.id)));
              }
              _matchEngine = MatchEngine(swipeItems: _swipeItems);
              return _buildPageLayout();
            }));
  }

  Center _buildPageLayout() {
    return Center(
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
    );
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
