import 'package:flashcards/features/db/models/collection.dart';
import 'package:flashcards/features/db/services/db_service.dart';
import 'package:flashcards/locator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../models/accessibility.dart';
import '../models/card_model.dart';
import '../models/card_set_model.dart';
import '../models/sets_filter.dart';

class SetsManagerService {
  final _dbService = getIt.get<DbService>();
  final allSets = BehaviorSubject.seeded([
    //TODO: connect with db
    CardSetModel(
        id: Uuid().v4(),
        ownerId: 1,
        setName: "some set",
        accessibility: Accessibility.public,
        cardList: [CardModel(id: "id", frontText: "asdf", backText: "iiii")]),
    CardSetModel(
        id: Uuid().v4(),
        ownerId: 1,
        setName: "Private set",
        accessibility: Accessibility.private,
        cardList: [
          CardModel(
              id: Uuid().v4(), frontText: "asdffront", backText: "basdack"),
          CardModel(id: Uuid().v4(), frontText: "iiii", backText: "bbbb")
        ]),
    CardSetModel(
        id: Uuid().v4(),
        ownerId: 1,
        setName: "Public set",
        accessibility: Accessibility.public,
        cardList: [
          CardModel(
              id: Uuid().v4(),
              frontText: "public front",
              backText: "public back")
        ])
  ]);

  Future<void> saveSet(CardSetModel cardSetModel) async {
    await _dbService.add(
        Collection.cardSets, cardSetModel.id, cardSetModel.toJson());
  }

  Future<CardSetModel> getSetWithId(String id) async {
    final setJson = await _dbService.getDocument(Collection.cardSets, id);
    return CardSetModel.fromJson(setJson);
    return Future.delayed(const Duration(seconds: 2)).then(
        ((value) => allSets.value.firstWhere((element) => element.id == id)));
  }

  Stream<List<CardSetModel>> get allSetsStream {
    return allSets.stream;
  }

  Stream<List<CardSetModel>> getFilteredSetsStream(SetsFilter setsFilter) {
    //TODO: add show just own filter
    return allSetsStream.map((allSetsList) => allSetsList
        .where((setList) => setList.accessibility == setsFilter.accessibility)
        .toList());
  }
}
