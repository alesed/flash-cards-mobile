import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../models/accessibility.dart';
import '../models/card_model.dart';
import '../models/card_set_model.dart';
import '../models/sets_filter.dart';

class SetsManagerService {
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
          CardModel(id: "3", frontText: "asdffront", backText: "basdack")
        ]),
    CardSetModel(
        id: Uuid().v4(),
        ownerId: 1,
        setName: "Public set",
        accessibility: Accessibility.public,
        cardList: [
          CardModel(id: "3", frontText: "public front", backText: "public back")
        ])
  ]);

  Future<void> saveSet(CardSetModel cardSetModel) async {
    //TODO: replace with push to db
    await Future.delayed(const Duration(seconds: 1));
    final allSetsUpdated = allSets.value;
    allSetsUpdated.removeWhere((element) => element.id == cardSetModel.id);
    allSets.add(allSets.value..add(cardSetModel));
  }

  Future<CardSetModel> getSetWithId(String id) {
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
