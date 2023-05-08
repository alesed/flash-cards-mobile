import 'package:flashcards/features/game/services/game_service.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flashcards/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

const _CARD_SIZE = 300.0;

class GamePage extends StatefulWidget {
  final String setId;
  final String setName;
  const GamePage({
    super.key,
    required this.setId,
    required this.setName,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _gameService = getIt.get<GameService>();
  final _setsManagerService = getIt.get<SetsManagerService>();

  MatchEngine? _matchEngine;
  @override
  void initState() {
    super.initState();
    _gameService.newGame(widget.setId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Practising \"${widget.setName}\""),
        ),
        drawer: CustomNavigationDrawer(),
        body: StreamBuilder<List<CardToShow>>(
            stream: _gameService.cardsToShowStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Err: ${snapshot.error.toString()}");
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final cardList = snapshot.data!;
              if (cardList.isEmpty) {
                return _buildFinishWidget();
              }
              final List<SwipeItem> swipeItems = [];
              for (final card in cardList) {
                swipeItems.add(SwipeItem(
                    content: card,
                    likeAction: () =>
                        _gameService.likeCard(card.originalCard.id),
                    nopeAction: () =>
                        _gameService.dislikeCard(card.originalCard.id)));
              }
              _matchEngine = MatchEngine(swipeItems: swipeItems);
              return _buildPageLayout(swipeItems);
            }));
  }

  FutureBuilder _buildFinishWidget() {
    return FutureBuilder<void>(
      future: updateStatsAfterFinished(),
      builder: (context, snapshot) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              Text("Finished!", style: TextStyle(fontSize: 20)),
              Spacer(),
              ElevatedButton(
                  onPressed: () => _gameService.newGame(widget.setId),
                  child: Text("Play again with all cards.")),
              if (_gameService.dislikedCardsCount > 0)
                ElevatedButton(
                    onPressed: () => _gameService.newGameWithFailedCards(),
                    child: Text("Play again with failed cards")),
              Text(
                  "Correctly answered cards: ${_gameService.likedCardsCount} / ${_gameService.setLength}"),
              Spacer(),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateStatsAfterFinished() async {
    if (_gameService.finished) return;
    await _setsManagerService.incrementPlaysCounter(widget.setId);
    await _setsManagerService.updateSuccessRate(
      widget.setId,
      _gameService.dislikedCardCount,
    );
    _gameService.finished = true;
  }

  Center _buildPageLayout(List<SwipeItem> swipeItems) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _CARD_SIZE,
            child: SwipeCards(
                likeTag: Icon(
                  Icons.thumb_up,
                  color: Colors.green,
                ),
                nopeTag: Icon(
                  Icons.thumb_down,
                  color: Colors.red,
                ),
                matchEngine: _matchEngine!,
                onStackFinished:
                    () {}, // This is not used, because we are using stream builder and it is not working together...
                itemBuilder: (_, index) {
                  return Center(child: _buildCard(swipeItems[index].content));
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

  Widget _buildCard(CardToShow cardToShow) {
    return SizedBox(
      width: _CARD_SIZE,
      height: _CARD_SIZE,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () => _gameService.turnCard(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    _gameService.showingCardFront ? "Front" : "Back",
                    style: TextStyle(color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    "${cardToShow.order}/${_gameService.setLength}",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              Spacer(),
              Text(
                cardToShow.textToShow,
                style: TextStyle(color: Colors.black),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
