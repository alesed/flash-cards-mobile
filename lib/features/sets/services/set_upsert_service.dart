import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flashcards/features/sets/models/save_state.dart';
import 'package:flashcards/features/sets/models/sets_filter.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../models/card_set_model.dart';

class SetUpsertService {
  final saveState = BehaviorSubject.seeded(SaveState.saved);
  final cardSet = BehaviorSubject<CardSetModel>();

  void createEmptySet() {
    cardSet.add(CardSetModel(
        id: Uuid().v4(),
        ownerId: 1,
        setName: "",
        accessibility: Accessibility.private,
        cardList: []));
  }

  Future<void> loadSet(String id) async {
    cardSet.add(await getIt.get<SetsManagerService>().getSetWithId(id));
  }

  CardSetModel get set {
    return cardSet
        .value; //TODO: is it correct, that we expect, that it is inicialized?
  }

  Future<void> save() async {
    await getIt
        .get<SetsManagerService>()
        .saveSet(cardSet.value); //TODO: same, should check?
    saveState.add(SaveState.notSaved);
  }

  void saveSet(CardSetModel cardSetModel) async {
    saveState.add(SaveState.saving);
    await getIt<SetsManagerService>().saveSet(
        cardSetModel); //TODO: what if this is not successful? How to pass error?
    saveState.add(SaveState.saved);
  }

  Stream<CardSetModel> get cardSetStream => cardSet.stream;
  Stream<SaveState> get isSavedStream => saveState.stream;

  void updateCardSet(CardSetModel cardSet) {
    this.cardSet.add(cardSet);
    saveState.add(SaveState.notSaved);
  }

  void addCard(CardModel card) {
    final currSet = cardSet.value;
    cardSet.add(currSet.copyWith(cardList: currSet.cardList..add(card)));
    saveState.add(SaveState.notSaved);
  }

  void deleteCard(String cardId) {
    final currSet = cardSet.value;
    cardSet.add(currSet.copyWith(
        cardList: currSet.cardList..removeWhere((card) => card.id == cardId)));
    saveState.add(SaveState.notSaved);
  }

  void updateCard(String cardId, CardModel newCard) {
    final currSet = cardSet.value;
    final currCards = cardSet.value.cardList;
    currCards[currCards.indexWhere((element) => element.id == cardId)] =
        newCard;
    cardSet.add(currSet.copyWith(cardList: currCards));
    saveState.add(SaveState.notSaved);
  }
}
