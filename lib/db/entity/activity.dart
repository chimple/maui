import 'package:maui/db/entity/quack_card.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'activity.g.dart';

@JsonSerializable(nullable: false)
class Activity extends Equatable {
  QuackCard card;
  List<String> templates;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  Activity({this.card, this.templates});

  @override
  String toString() {
    return 'card: $card, templates: $templates';
  }
}
