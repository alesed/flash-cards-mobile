import 'accessibility.dart';
import 'card_model.dart';

class CardSetModel {
  final int ownerId;
  final String setName;
  final Accessibility accessibility;
  final List<CardModel> cardList;

  const CardSetModel(
      {required this.ownerId,
      required this.setName,
      required this.accessibility,
      required this.cardList});

  CardSetModel copyWith(
      {int? ownerId,
      String? setName,
      Accessibility? accessibility,
      List<CardModel>? cardList}) {
    return CardSetModel(
        ownerId: ownerId ?? this.ownerId,
        setName: setName ?? this.setName,
        accessibility: accessibility ?? this.accessibility,
        cardList: cardList ?? this.cardList);
  }
}
