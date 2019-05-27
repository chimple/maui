import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'display_item.g.dart';

abstract class DisplayItem implements Built<DisplayItem, DisplayItemBuilder> {
  String get item;
  DisplayTypeEnum get displayType;

  @nullable
  String get image;

  @nullable
  String get audio;

  DisplayItem._();
  factory DisplayItem([updates(DisplayItemBuilder b)]) = _$DisplayItem;
  static Serializer<DisplayItem> get serializer => _$displayItemSerializer;
}

class DisplayTypeEnum extends EnumClass {
  static Serializer<DisplayTypeEnum> get serializer =>
      _$displayTypeEnumSerializer;

  static const DisplayTypeEnum letter = _$letter;
  static const DisplayTypeEnum syllable = _$syllable;
  static const DisplayTypeEnum word = _$word;
  static const DisplayTypeEnum sentence = _$sentence;
  static const DisplayTypeEnum image = _$image;
  static const DisplayTypeEnum audio = _$audio;

  const DisplayTypeEnum._(String name) : super(name);

  static BuiltSet<DisplayTypeEnum> get values => _$values;
  static DisplayTypeEnum valueOf(String name) => _$valueOf(name);
}
