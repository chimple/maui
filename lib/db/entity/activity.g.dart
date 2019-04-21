// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
      card: QuackCard.fromJson(json['card'] as Map<String, dynamic>),
      templates: (json['templates'] as List).map((e) => e as String).toList());
}

Map<String, dynamic> _$ActivityToJson(Activity instance) =>
    <String, dynamic>{'card': instance.card, 'templates': instance.templates};
