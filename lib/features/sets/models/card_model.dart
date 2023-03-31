import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'card_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CardModel {
  final String id;
  final String frontText;
  final String backText;
  CardModel(
      {required this.id, required this.frontText, required this.backText});

  CardModel copyWith({String? id, String? frontText, String? backText}) {
    return CardModel(
        id: id ?? this.id,
        frontText: frontText ?? this.frontText,
        backText: backText ?? this.backText);
  }

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardModelToJson(this);
}
