import 'package:maui/db/entity/activity.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'chapter.g.dart';

@JsonSerializable(nullable: false)
class Chapter extends Equatable {
  @JsonKey(nullable: true)
  List<QuackCard> knowledges;

  @JsonKey(nullable: true)
  List<Activity> activities;

  @JsonKey(nullable: true)
  List<Quiz> quizzes;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterToJson(this);

  Chapter({this.knowledges, this.activities, this.quizzes});

  @override
  String toString() {
    return 'knowledges: ${knowledges}, activities: ${activities}, quizzes: ${quizzes}';
  }
}
