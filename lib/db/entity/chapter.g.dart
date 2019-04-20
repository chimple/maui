// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return Chapter(
      knowledges: (json['knowledges'] as List)
          ?.map((e) =>
              e == null ? null : QuackCard.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      activities: (json['activities'] as List)
          ?.map((e) =>
              e == null ? null : Activity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      quizzes: (json['quizzes'] as List)
          ?.map((e) =>
              e == null ? null : Quiz.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'knowledges': instance.knowledges,
      'activities': instance.activities,
      'quizzes': instance.quizzes
    };
