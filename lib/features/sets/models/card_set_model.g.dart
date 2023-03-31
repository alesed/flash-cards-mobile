// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_set_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardSetModel _$CardSetModelFromJson(Map<String, dynamic> json) => CardSetModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as int,
      setName: json['set_name'] as String,
      accessibility: $enumDecode(_$AccessibilityEnumMap, json['accessibility']),
      cardList: (json['card_list'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CardSetModelToJson(CardSetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'set_name': instance.setName,
      'accessibility': _$AccessibilityEnumMap[instance.accessibility]!,
      'card_list': instance.cardList.map((e) => e.toJson()).toList(),
    };

const _$AccessibilityEnumMap = {
  Accessibility.public: 'public',
  Accessibility.private: 'private',
};
