// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quack_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuackCard _$QuackCardFromJson(Map<String, dynamic> json) {
  return QuackCard(
      id: json['id'] as String,
      type: _$enumDecode(_$CardTypeEnumMap, json['type']),
      title: json['title'] as String,
      titleAudio: json['titleAudio'] as String,
      header: json['header'] as String,
      content: json['content'] as String,
      contentAudio: json['contentAudio'] as String,
      option: json['option'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int);
}

Map<String, dynamic> _$QuackCardToJson(QuackCard instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$CardTypeEnumMap[instance.type],
      'title': instance.title,
      'titleAudio': instance.titleAudio,
      'header': instance.header,
      'content': instance.content,
      'contentAudio': instance.contentAudio,
      'option': instance.option,
      'likes': instance.likes,
      'comments': instance.comments
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

const _$CardTypeEnumMap = <CardType, dynamic>{
  CardType.question: 'question',
  CardType.activity: 'activity',
  CardType.concept: 'concept',
  CardType.knowledge: 'knowledge'
};
