import 'package:flashcards/features/game/models/answer_state.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

const _MAX_CARD_STACK_COUNT = 3;

class AnsweredCard {
  CardModel cardModel;
  AnswerState answerState;
  double timeToAnswer;

  AnsweredCard(
      {required this.cardModel,
      required this.answerState,
      required this.timeToAnswer});
}

class CardToShow {
  String textToShow;
  int order;
  CardModel originalCard;
  CardToShow(
      {required this.textToShow,
      required this.order,
      required this.originalCard});
  CardToShow copyWith({String? textToShow}) {
    return CardToShow(
        textToShow: textToShow ?? this.textToShow,
        originalCard: originalCard,
        order: order);
  }
}

class GameService {
  bool _showingCardFront = true;
  List<AnsweredCard> answeredCardList = [];
  List<CardModel> allCardsList = [];
  final cardsToShow = BehaviorSubject<List<CardToShow>>();

  void newGameWithFailedCards() {
    final failedCards = answeredCardList
        .where((element) => element.answerState == AnswerState.disliked)
        .map((e) => e.cardModel)
        .toList();
    _initNewGame(failedCards);
  }

  void _initNewGame(List<CardModel> cards) {
    answeredCardList = [];
    allCardsList = cards;
    cardsToShow.add(allCardsList.asMap().entries.map((entry) {
      int index = entry.key;
      final card = entry.value;
      return CardToShow(
          textToShow: card.frontText, order: index + 1, originalCard: card);
    }).toList());
  }

  void newGame(String setId) async {
    final cardSet = await getIt.get<SetsManagerService>().getSetWithId(
        setId); //TODO: modifies original list, will be solved later, when using db...
    _initNewGame(cardSet.cardList);
  }

  bool get showingCardFront => _showingCardFront;

  int get setLength => allCardsList.length;

  int get likedCardsCount => getAnsweredCardWithStateCount(AnswerState.liked);
  int get dislikedCardsCount =>
      getAnsweredCardWithStateCount(AnswerState.disliked);
  int getAnsweredCardWithStateCount(AnswerState answerState) {
    return answeredCardList
        .where((element) => element.answerState == answerState)
        .length;
  }

  Stream<List<CardToShow>> get cardsToShowStream => cardsToShow.stream;

  void turnCard() {
    final cardsToShowList = cardsToShow.value.map((cardToShow) {
      return cardToShow.copyWith(
          textToShow: _showingCardFront
              ? cardToShow.originalCard.backText
              : cardToShow.originalCard.frontText);
    }).toList();

    cardsToShow.add(cardsToShowList);
    _showingCardFront = !_showingCardFront;
  }

  void removeRestingCard(String cardId) {
    cardsToShow.add(cardsToShow.value
      ..removeWhere((cardToShow) => cardToShow.originalCard.id == cardId));
  }

  void likeCard(String cardId) {
    answeredCardList.add(AnsweredCard(
        cardModel: allCardsList.firstWhere((element) => element.id == cardId),
        answerState: AnswerState.liked,
        timeToAnswer: 1.0));
    removeRestingCard(cardId);
  }

  void dislikeCard(String cardId) {
    answeredCardList.add(AnsweredCard(
        cardModel: allCardsList.firstWhere((element) => element.id == cardId),
        answerState: AnswerState.disliked,
        timeToAnswer: 1.0));
    removeRestingCard(cardId);
  }
}
