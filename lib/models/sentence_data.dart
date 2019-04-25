import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_data.dart';

part 'sentence_data.g.dart';

abstract class SentenceData
    implements Built<SentenceData, SentenceDataBuilder>, GameData {
  @override
  String get gameId;

  BuiltList<BuiltList<WordWithImage>> get wordWithImages;
  BuiltList<String> get headers;

  SentenceData._();
  factory SentenceData([updates(SentenceDataBuilder b)]) = _$SentenceData;
  static Serializer<SentenceData> get serializer => _$sentenceDataSerializer;
}

abstract class WordWithImage
    implements Built<WordWithImage, WordWithImageBuilder> {
  String get word;

  @nullable
  String get image;

  WordWithImage._();
  factory WordWithImage([updates(WordWithImageBuilder b)]) = _$WordWithImage;
  static Serializer<WordWithImage> get serializer => _$wordWithImageSerializer;
}
