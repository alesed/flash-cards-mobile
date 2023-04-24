import 'package:flashcards/features/db/models/collection.dart';
import 'package:flashcards/features/db/services/db_service.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/sets_filter.dart';
import 'package:flashcards/locator.dart';

class SetsManagerService {
  final _dbService = getIt.get<DbService>();

  Future<void> saveSet(CardSetModel cardSetModel) async {
    return await _dbService.add(
        Collection.cardSets, cardSetModel.id, cardSetModel.toJson());
  }

  Future<CardSetModel> getSetWithId(String id) async {
    final setJson = await _dbService.getDocument(Collection.cardSets, id);
    return CardSetModel.fromJson(setJson);
  }

  Stream<List<CardSetModel>> get allSetsStream {
    return _dbService.getCollectionStream(Collection.cardSets).map((jsonList) =>
        jsonList.map((jsonItem) => CardSetModel.fromJson(jsonItem)).toList());
  }

  Stream<List<CardSetModel>> getFilteredSetsStream(SetsFilter setsFilter) {
    //TODO: add show just own filter
    return allSetsStream.map((allSetsList) => allSetsList
        .where((setList) => setList.accessibility == setsFilter.accessibility)
        .toList());
  }

  Future<void> deleteSet(String id) async {
    await Future.delayed(
        const Duration(seconds: 1)); //TODO: remove later, simulates latency
    return _dbService.deleteDocument(Collection.cardSets, id);
  }
}
