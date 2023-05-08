import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/save_state.dart';
import 'package:flashcards/features/sets/services/sets_manager_service.dart';
import 'package:flashcards/locator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class SetUpsertService {
  final _authService = getIt<AuthenticationService>();
  final _setsManagerService = getIt<SetsManagerService>();

  final saveState = BehaviorSubject.seeded(SaveState.saved);
  final cardSet = BehaviorSubject<CardSetModel>();

  void createEmptySet() {
    cardSet.add(CardSetModel(
      id: Uuid().v4(),
      ownerId: _authService.currentUser!.uid ?? "",
      setName: "",
      accessibility: Accessibility.private,
      cardList: [],
      playsCounter: 0,
      successRate: -1,
    ));
  }

  Future<void> loadSet(String id) async {
    cardSet.add(await _setsManagerService.getSetWithId(id));
  }

  CardSetModel get set {
    return cardSet.value;
  }

  Future<void> save() async {
    await _setsManagerService.saveSet(cardSet.value);
    saveState.add(SaveState.notSaved);
  }

  void saveSet(CardSetModel cardSetModel) async {
    saveState.add(SaveState.saving);
    await _setsManagerService.saveSet(cardSetModel);
    saveState.add(SaveState.saved);
  }

  Stream<CardSetModel> get cardSetStream => cardSet.stream;
  Stream<SaveState> get isSavedStream => saveState.stream;

  void updateCardSet(CardSetModel cardSet) {
    this.cardSet.add(cardSet);
    saveState.add(SaveState.notSaved);
  }

  void addCard(CardModel card) {
    final currentSet = cardSet.value;
    cardSet.add(currentSet.copyWith(cardList: currentSet.cardList..add(card)));
    saveState.add(SaveState.notSaved);
  }

  void deleteCard(String cardId) {
    final currentSet = cardSet.value;
    cardSet.add(currentSet.copyWith(
        cardList: currentSet.cardList
          ..removeWhere((card) => card.id == cardId)));
    saveState.add(SaveState.notSaved);
  }

  void updateCard(String cardId, CardModel newCard) {
    final currentSet = cardSet.value;
    final currentCards = cardSet.value.cardList;
    currentCards[currentCards.indexWhere((element) => element.id == cardId)] =
        newCard;
    cardSet.add(currentSet.copyWith(cardList: currentCards));
    saveState.add(SaveState.notSaved);
  }
}
