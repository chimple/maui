// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) {
  return UserActivity(
      like: json['like'] as bool,
      total: json['total'] as int,
      done: json['done'] as int);
}

Map<String, dynamic> _$UserActivityToJson(UserActivity instance) =>
    <String, dynamic>{
      'like': instance.like,
      'total': instance.total,
      'done': instance.done
    };
