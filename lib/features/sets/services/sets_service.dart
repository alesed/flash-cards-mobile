import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SetsService {
  int ownerId = 1;
  String setName = "Default";
  Accessibility accessibility = Accessibility.private;
  final cardList = BehaviorSubject<List<CardModel>>.seeded([]);

  void createNewSet() {
    //TODO: maybe bad architecture?
  }

  void loadSet(String id) {}

  Stream<List<CardModel>> get addedCards => cardList.stream;

  void addCard(CardModel card) {
    final lastSet = cardList.value;
    cardList.add(lastSet..add(card));
  }

  void deleteCard(String cardId) {
    final lastList = cardList.value;
    cardList.add(lastList..removeWhere((card) => card.id == cardId));
  }

  void updateCard(String cardId, CardModel newCard) {
    final lastList = cardList.value;
    lastList[lastList.indexWhere((card) => card.id == cardId)] = newCard;
    cardList.add(lastList);
  }
}
