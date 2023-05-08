// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_set_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardSetModel _$CardSetModelFromJson(Map<String, dynamic> json) => CardSetModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      setName: json['set_name'] as String,
      accessibility: $enumDecode(_$AccessibilityEnumMap, json['accessibility']),
      cardList: (json['card_list'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      playsCounter: json['plays_counter'] as int,
      successRate: (json['success_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$CardSetModelToJson(CardSetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'set_name': instance.setName,
      'accessibility': _$AccessibilityEnumMap[instance.accessibility]!,
      'card_list': instance.cardList.map((e) => e.toJson()).toList(),
      'plays_counter': instance.playsCounter,
      'success_rate': instance.successRate,
    };

const _$AccessibilityEnumMap = {
  Accessibility.public: 'public',
  Accessibility.private: 'private',
};
