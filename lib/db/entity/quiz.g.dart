// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return Quiz(
      id: json['id'] as String,
      type: _$enumDecode(_$QuizTypeEnumMap, json['type']),
      question: json['question'] as String,
      questionAudio: json['questionAudio'] as String,
      header: json['header'] as String,
      answers: (json['answers'] as List)?.map((e) => e as String)?.toList(),
      answerAudios:
          (json['answerAudios'] as List)?.map((e) => e as String)?.toList(),
      choices: (json['choices'] as List)?.map((e) => e as String)?.toList(),
      choiceAudios:
          (json['choiceAudios'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$QuizTypeEnumMap[instance.type],
      'question': instance.question,
      'questionAudio': instance.questionAudio,
      'header': instance.header,
      'answers': instance.answers,
      'answerAudios': instance.answerAudios,
      'choices': instance.choices,
      'choiceAudios': instance.choiceAudios
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

const _$QuizTypeEnumMap = <QuizType, dynamic>{
  QuizType.oneAtATime: 'oneAtATime',
  QuizType.many: 'many',
  QuizType.pair: 'pair',
  QuizType.open: 'open'
};
