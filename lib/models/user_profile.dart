library user_profile;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_status.dart';

part 'user_profile.g.dart';

abstract class UserProfile implements Built<UserProfile, UserProfileBuilder> {
  String get name;
  String get currentTheme;
  BuiltMap<String, GameStatus> get gameStatuses;
  BuiltMap<String, int> get items;
  BuiltMap<String, String> get accessories;

  UserProfile._();
  factory UserProfile([updates(UserProfileBuilder b)]) = _$UserProfile;
  static Serializer<UserProfile> get serializer => _$userProfileSerializer;
}

abstract class UserProfileBuilder
    implements Builder<UserProfile, UserProfileBuilder> {
  String name = '';
  String currentTheme = '';
  BuiltMap<String, GameStatus> gameStatuses = BuiltMap<String, GameStatus>({});
  BuiltMap<String, int> items = BuiltMap<String, int>({});
  BuiltMap<String, String> accessories = BuiltMap<String, String>({});

  factory UserProfileBuilder() = _$UserProfileBuilder;
  UserProfileBuilder._();
}
