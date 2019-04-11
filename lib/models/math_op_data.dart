import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_data.dart';

part 'math_op_data.g.dart';

abstract class MathOpData
    implements Built<MathOpData, MathOpDataBuilder>, GameData {
  @override
  String get gameId;

  int get first;

  int get second;

  String get op;

  int get answer;

  MathOpData._();
  factory MathOpData([updates(MathOpDataBuilder b)]) = _$MathOpData;
  static Serializer<MathOpData> get serializer => _$mathOpDataSerializer;
}
