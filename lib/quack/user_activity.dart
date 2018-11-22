import 'package:json_annotation/json_annotation.dart';
part 'user_activity.g.dart';

@JsonSerializable()
class UserActivity {
  UserActivity({this.like, this.total, this.done});

  bool like;
  int total;
  int done;

  double get progress => done == null ? null : done / (total ?? 1);

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);

  Map<String, dynamic> toJson() => _$UserActivityToJson(this);

  @override
  int get hashCode => like.hashCode ^ total.hashCode ^ done.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserActivity &&
          runtimeType == other.runtimeType &&
          like == other.like &&
          total == other.total &&
          done == other.done;

  @override
  String toString() {
    return 'UserActivity{like: $like, done: $done, total: $total}';
  }
}
