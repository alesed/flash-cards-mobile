import 'package:json_annotation/json_annotation.dart';

import 'accessibility.dart';
import 'card_model.dart';

part 'card_set_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CardSetModel {
  final String id;
  final int ownerId;
  final String setName;
  final Accessibility accessibility;
  final List<CardModel> cardList;

  const CardSetModel(
      {required this.id,
      required this.ownerId,
      required this.setName,
      required this.accessibility,
      required this.cardList});

  CardSetModel copyWith(
      {int? ownerId,
      String? setName,
      Accessibility? accessibility,
      List<CardModel>? cardList}) {
    return CardSetModel(
        id: id,
        ownerId: ownerId ?? this.ownerId,
        setName: setName ?? this.setName,
        accessibility: accessibility ?? this.accessibility,
        cardList: cardList ?? this.cardList);
  }

  factory CardSetModel.fromJson(Map<String, dynamic> json) =>
      _$CardSetModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardSetModelToJson(this);
}
