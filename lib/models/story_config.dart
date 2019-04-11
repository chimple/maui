import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'story_config.g.dart';

abstract class StoryConfig implements Built<StoryConfig, StoryConfigBuilder> {
  String get storyId;
  String get coverImagePath;
  String get title;
  BuiltList<Page> get pages;

  StoryConfig._();
  factory StoryConfig([updates(StoryConfigBuilder b)]) = _$StoryConfig;
  static Serializer<StoryConfig> get serializer => _$storyConfigSerializer;
}

abstract class Page implements Built<Page, PageBuilder> {
  String get pageNumber;
  String get imagePath;
  String get text;
  String get audioPath;
  BuiltList<ImageItemDetail> get imageitemDetails;
  Page._();
  factory Page([updates(PageBuilder b)]) = _$Page;
  static Serializer<Page> get serializer => _$pageSerializer;
}

abstract class ImageItemDetail implements Built<ImageItemDetail, ImageItemDetailBuilder> 
{
  String get itemName;
  String get x;
  String get y;
  String get height;
  String get width;
  ImageItemDetail._();
  factory ImageItemDetail([updates(ImageItemDetailBuilder b)]) = _$ImageItemDetail;
  static Serializer<ImageItemDetail> get serializer => _$imageItemDetailSerializer;
}
 
abstract class Stories implements Built<Stories, StoriesBuilder> {
  BuiltList<StoryConfig> get stories;

  Stories._();
  factory Stories([updates(StoriesBuilder b)]) = _$Stories;
  static Serializer<Stories> get serializer => _$storiesSerializer;
}
