import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/game_data.dart';

part 'image_label_data.g.dart';

abstract class ImageLabelData
    implements Built<ImageLabelData, ImageLabelDataBuilder>, GameData {
  @override
  String get gameId;

  BuiltList<ImageItemDetail> get imageItemDetails;
  ImageLabelData._();
  factory ImageLabelData([updates(ImageLabelDataBuilder b)]) = _$ImageLabelData;
  static Serializer<ImageLabelData> get serializer =>
      _$imageLabelDataSerializer;
}

abstract class ImageItemDetail
    implements Built<ImageItemDetail, ImageItemDetailBuilder> {
  String get itemName;
  String get x;
  String get y;
  String get height;
  String get width;
  ImageItemDetail._();
  factory ImageItemDetail([updates(ImageItemDetailBuilder b)]) =
      _$ImageItemDetail;
  static Serializer<ImageItemDetail> get serializer =>
      _$imageItemDetailSerializer;
}
