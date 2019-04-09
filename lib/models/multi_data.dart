import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_data.dart';

part 'multi_data.g.dart';

abstract class MultiData
    implements Built<MultiData, MultiDataBuilder>, GameData {
  @override
  String get gameId;

  @nullable
  String get question;

  @nullable
  BuiltList<String> get specials;

  @nullable
  BuiltList<String> get choices;

  BuiltList<String> get answers;

  MultiData._();
  factory MultiData([updates(MultiDataBuilder b)]) = _$MultiData;
  static Serializer<MultiData> get serializer => _$multiDataSerializer;
}
