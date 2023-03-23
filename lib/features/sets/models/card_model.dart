import 'package:uuid/uuid.dart';

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
}
