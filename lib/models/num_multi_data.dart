import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_data.dart';

part 'num_multi_data.g.dart';

abstract class NumMultiData
    implements Built<NumMultiData, NumMultiDataBuilder>, GameData {
  @override
  String get gameId;

  @nullable
  String get question;

  BuiltList<int> get answers;

  @nullable
  BuiltList<int> get choices;

  @nullable
  BuiltList<int> get specials;

  NumMultiData._();
  factory NumMultiData([updates(NumMultiDataBuilder b)]) = _$NumMultiData;
  static Serializer<NumMultiData> get serializer => _$numMultiDataSerializer;
}
