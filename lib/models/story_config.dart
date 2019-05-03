import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_data.dart';

part 'story_config.g.dart';

abstract class StoryConfig implements Built<StoryConfig, StoryConfigBuilder> {
  String get storyId;
  String get coverImagePath;
  String get title;
  BuiltList<Page> get pages;
  @nullable
  BuiltList<GameData> get gameDatas;

  StoryConfig._();
  factory StoryConfig([updates(StoryConfigBuilder b)]) = _$StoryConfig;
  static Serializer<StoryConfig> get serializer => _$storyConfigSerializer;
}

abstract class Page implements Built<Page, PageBuilder> {
  @nullable
  String get imagePath;

  @nullable
  String get text;

  @nullable
  String get audioPath;

  Page._();
  factory Page([updates(PageBuilder b)]) = _$Page;
  static Serializer<Page> get serializer => _$pageSerializer;
}

abstract class Stories implements Built<Stories, StoriesBuilder> {
  BuiltList<StoryConfig> get stories;

  Stories._();
  factory Stories([updates(StoriesBuilder b)]) = _$Stories;
  static Serializer<Stories> get serializer => _$storiesSerializer;
}
