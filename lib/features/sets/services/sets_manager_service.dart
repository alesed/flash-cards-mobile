import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/features/db/models/collection.dart';
import 'package:flashcards/features/db/services/db_service.dart';
import 'package:flashcards/features/sets/models/card_set_model.dart';
import 'package:flashcards/features/sets/models/sets_filter.dart';
import 'package:flashcards/locator.dart';

class SetsManagerService {
  final _dbService = getIt<DbService>();
  final _authService = getIt<AuthenticationService>();

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
    return allSetsStream.map((allSetsList) => allSetsList
        .where((setList) => setList.accessibility == setsFilter.accessibility)
        .where((setList) => setsFilter.justOwn
            ? setList.ownerId == _authService.currentUser!.uid
            : true)
        .toList());
  }

  Future<void> deleteSet(String id) async {
    return _dbService.deleteDocument(Collection.cardSets, id);
  }

  Future<void> incrementPlaysCounter(String id) async {
    return await _dbService.update(Collection.cardSets, id, {
      "plays_counter": FieldValue.increment(1),
    });
  }

  Future<void> updateSuccessRate(String id, int dislikedCount) async {
    CardSetModel set = await getSetWithId(id);
    double successRate = 1 - (dislikedCount / set.cardList.length);
    double newSuccessRate =
        calculateSuccessRate(set.successRate, set.playsCounter, successRate);
    return await _dbService.update(Collection.cardSets, id, {
      "success_rate": newSuccessRate,
    });
  }

  double calculateSuccessRate(
      double currentSuccessRate, int playsCounter, double successRateOfGame) {
    if (currentSuccessRate == -1) return successRateOfGame;
    return ((currentSuccessRate * playsCounter) + successRateOfGame) /
        (playsCounter + 1);
  }
}
