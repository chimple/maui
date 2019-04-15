import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_data.dart';

part 'crossword_data.g.dart';

abstract class CrosswordData
    implements Built<CrosswordData, CrosswordDataBuilder>, GameData {
  @override
  String get gameId;
  BuiltList<ImageData> get images;
  BuiltList<BuiltList<String>> get data;

  CrosswordData._();
  factory CrosswordData([updates(CrosswordDataBuilder b)]) = _$CrosswordData;
  static Serializer<CrosswordData> get serializer => _$crosswordDataSerializer;
}

abstract class ImageData implements Built<ImageData, ImageDataBuilder> {
  String get image;
  int get x;
  int get y;

  ImageData._();
  factory ImageData([updates(ImageDataBuilder b)]) = _$ImageData;
  static Serializer<ImageData> get serializer => _$imageDataSerializer;
}
