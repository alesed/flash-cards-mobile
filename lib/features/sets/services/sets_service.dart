import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flutter/material.dart';

List<CardModel> cards = [
  CardModel(frontText: "frontText", backText: "backText"),
  CardModel(frontText: "frontText2", backText: "backText2")
];

class SetsService {
  final CardSetModel cardSet = CardSetModel(
      ownerId: 1,
      name: "biology",
      accessibility: Accessibility.private,
      cardList: cards);
  final List<CardSetModel> cardSets = [];

  Future<CardSetModel> getCardSetById(String id) {
    return Future.delayed(const Duration(seconds: 1),
        () => cardSets.firstWhere((cardSet) => cardSet.id == id));
  }

  Future<void> createSet(CardSetModel cardSet) {
    return Future.delayed(
        const Duration(seconds: 1), () => cardSets.add(cardSet));
  }
}
