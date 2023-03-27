import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:rxdart/rxdart.dart';

import '../models/card_set_model.dart';

class SetsService {
  final cardSet = BehaviorSubject<CardSetModel>();

  void createEmptySet() {
    cardSet.add(CardSetModel(
        ownerId: 1,
        setName: "",
        accessibility: Accessibility.private,
        cardList: []));
  }

  Future<void> loadSet(String id) async {
    await Future.delayed(
        const Duration(seconds: 3)); //TODO: remove (just simulates network)
    cardSet.add(CardSetModel(
        ownerId: 1,
        setName: "loaded set",
        accessibility: Accessibility.public,
        cardList: [CardModel(id: "id", frontText: "asdf", backText: "iiii")]));
  }

  Stream<CardSetModel> get cardSetStream => cardSet.stream;

  void updateCardSet(CardSetModel cardSet) {
    this.cardSet.add(cardSet);
  }

  void addCard(CardModel card) {
    final currSet = cardSet.value;
    cardSet.add(currSet.copyWith(cardList: currSet.cardList..add(card)));
  }

  void deleteCard(String cardId) {
    final currSet = cardSet.value;
    cardSet.add(currSet.copyWith(
        cardList: currSet.cardList..removeWhere((card) => card.id == cardId)));
  }

  void updateCard(String cardId, CardModel newCard) {
    final currSet = cardSet.value;
    final currCards = cardSet.value.cardList;
    currCards[currCards.indexWhere((element) => element.id == cardId)] =
        newCard;
    cardSet.add(currSet.copyWith(cardList: currCards));
  }
}
