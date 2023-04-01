import 'package:flashcards/features/game/models/answer_state.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AnsweredCard {
  CardModel cardModel;
  AnswerState answerState;
  double timeToAnswer;

  AnsweredCard(
      {required this.cardModel,
      required this.answerState,
      required this.timeToAnswer});
}

class GameService {
  List<CardModel> cardList = [];
  List<AnsweredCard> answeredCardList = [];
  final restingCards = BehaviorSubject<List<CardModel>>();

  void newGame(String setId) async {
    final cardSet = await getIt.get<SetsManagerService>().getSetWithId(setId);
    restingCards.add(cardSet.cardList);
  }

  Stream<List<CardModel>> get restingCardsStream => restingCards.stream;

  void removeRestingCard(String cardId) {
    restingCards.add(
        restingCards.value..removeWhere((element) => element.id == cardId));
  }

  void likeCard(String cardId) {
    answeredCardList.add(AnsweredCard(
        cardModel: cardList.firstWhere((element) => element.id == cardId),
        answerState: AnswerState.liked,
        timeToAnswer: 1.0));
    removeRestingCard(cardId);
  }

  void dislikeCard(String cardId) {
    answeredCardList.add(AnsweredCard(
        cardModel: cardList.firstWhere((element) => element.id == cardId),
        answerState: AnswerState.disliked,
        timeToAnswer: 1.0));
    removeRestingCard(cardId);
  }
}
