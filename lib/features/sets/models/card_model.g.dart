// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
      id: json['id'] as String,
      frontText: json['front_text'] as String,
      backText: json['back_text'] as String,
    );

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
      'id': instance.id,
      'front_text': instance.frontText,
      'back_text': instance.backText,
    };
