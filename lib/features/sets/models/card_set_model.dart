import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/card_model.dart';
import 'package:uuid/uuid.dart';

class CardSetModel {
  var id = Uuid().v4();
  final int ownerId;
  final String name;
  final Accessibility accessibility;
  List<CardModel> cardList = [];

  CardSetModel(
      {required this.ownerId,
      required this.name,
      required this.accessibility,
      required this.cardList});
}
