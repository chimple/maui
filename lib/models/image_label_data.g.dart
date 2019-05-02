// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_label_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ImageLabelData> _$imageLabelDataSerializer =
    new _$ImageLabelDataSerializer();
Serializer<ImageItemDetail> _$imageItemDetailSerializer =
    new _$ImageItemDetailSerializer();

class _$ImageLabelDataSerializer
    implements StructuredSerializer<ImageLabelData> {
  @override
  final Iterable<Type> types = const [ImageLabelData, _$ImageLabelData];
  @override
  final String wireName = 'ImageLabelData';

  @override
  Iterable serialize(Serializers serializers, ImageLabelData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'imageName',
      serializers.serialize(object.imageName,
          specifiedType: const FullType(String)),
      'imageItemDetails',
      serializers.serialize(object.imageItemDetails,
          specifiedType: const FullType(
              BuiltList, const [const FullType(ImageItemDetail)])),
    ];

    return result;
  }

  @override
  ImageLabelData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ImageLabelDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'gameId':
          result.gameId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'imageName':
          result.imageName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'imageItemDetails':
          result.imageItemDetails.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ImageItemDetail)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ImageItemDetailSerializer
    implements StructuredSerializer<ImageItemDetail> {
  @override
  final Iterable<Type> types = const [ImageItemDetail, _$ImageItemDetail];
  @override
  final String wireName = 'ImageItemDetail';

  @override
  Iterable serialize(Serializers serializers, ImageItemDetail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'itemName',
      serializers.serialize(object.itemName,
          specifiedType: const FullType(String)),
      'x',
      serializers.serialize(object.x, specifiedType: const FullType(String)),
      'y',
      serializers.serialize(object.y, specifiedType: const FullType(String)),
      'height',
      serializers.serialize(object.height,
          specifiedType: const FullType(String)),
      'width',
      serializers.serialize(object.width,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ImageItemDetail deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ImageItemDetailBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'itemName':
          result.itemName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'x':
          result.x = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'y':
          result.y = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'height':
          result.height = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'width':
          result.width = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ImageLabelData extends ImageLabelData {
  @override
  final String gameId;
  @override
  final String imageName;
  @override
  final BuiltList<ImageItemDetail> imageItemDetails;

  factory _$ImageLabelData([void Function(ImageLabelDataBuilder) updates]) =>
      (new ImageLabelDataBuilder()..update(updates)).build();

  _$ImageLabelData._({this.gameId, this.imageName, this.imageItemDetails})
      : super._() {
    if (gameId == null) {
      throw new BuiltValueNullFieldError('ImageLabelData', 'gameId');
    }
    if (imageName == null) {
      throw new BuiltValueNullFieldError('ImageLabelData', 'imageName');
    }
    if (imageItemDetails == null) {
      throw new BuiltValueNullFieldError('ImageLabelData', 'imageItemDetails');
    }
  }

  @override
  ImageLabelData rebuild(void Function(ImageLabelDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImageLabelDataBuilder toBuilder() =>
      new ImageLabelDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageLabelData &&
        gameId == other.gameId &&
        imageName == other.imageName &&
        imageItemDetails == other.imageItemDetails;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, gameId.hashCode), imageName.hashCode),
        imageItemDetails.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ImageLabelData')
          ..add('gameId', gameId)
          ..add('imageName', imageName)
          ..add('imageItemDetails', imageItemDetails))
        .toString();
  }
}

class ImageLabelDataBuilder
    implements Builder<ImageLabelData, ImageLabelDataBuilder>, GameDataBuilder {
  _$ImageLabelData _$v;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  String _imageName;
  String get imageName => _$this._imageName;
  set imageName(String imageName) => _$this._imageName = imageName;

  ListBuilder<ImageItemDetail> _imageItemDetails;
  ListBuilder<ImageItemDetail> get imageItemDetails =>
      _$this._imageItemDetails ??= new ListBuilder<ImageItemDetail>();
  set imageItemDetails(ListBuilder<ImageItemDetail> imageItemDetails) =>
      _$this._imageItemDetails = imageItemDetails;

  ImageLabelDataBuilder();

  ImageLabelDataBuilder get _$this {
    if (_$v != null) {
      _gameId = _$v.gameId;
      _imageName = _$v.imageName;
      _imageItemDetails = _$v.imageItemDetails?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant ImageLabelData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ImageLabelData;
  }

  @override
  void update(void Function(ImageLabelDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ImageLabelData build() {
    _$ImageLabelData _$result;
    try {
      _$result = _$v ??
          new _$ImageLabelData._(
              gameId: gameId,
              imageName: imageName,
              imageItemDetails: imageItemDetails.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'imageItemDetails';
        imageItemDetails.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ImageLabelData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ImageItemDetail extends ImageItemDetail {
  @override
  final String itemName;
  @override
  final String x;
  @override
  final String y;
  @override
  final String height;
  @override
  final String width;

  factory _$ImageItemDetail([void Function(ImageItemDetailBuilder) updates]) =>
      (new ImageItemDetailBuilder()..update(updates)).build();

  _$ImageItemDetail._({this.itemName, this.x, this.y, this.height, this.width})
      : super._() {
    if (itemName == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'itemName');
    }
    if (x == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'x');
    }
    if (y == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'y');
    }
    if (height == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'height');
    }
    if (width == null) {
      throw new BuiltValueNullFieldError('ImageItemDetail', 'width');
    }
  }

  @override
  ImageItemDetail rebuild(void Function(ImageItemDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImageItemDetailBuilder toBuilder() =>
      new ImageItemDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageItemDetail &&
        itemName == other.itemName &&
        x == other.x &&
        y == other.y &&
        height == other.height &&
        width == other.width;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, itemName.hashCode), x.hashCode), y.hashCode),
            height.hashCode),
        width.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ImageItemDetail')
          ..add('itemName', itemName)
          ..add('x', x)
          ..add('y', y)
          ..add('height', height)
          ..add('width', width))
        .toString();
  }
}

class ImageItemDetailBuilder
    implements Builder<ImageItemDetail, ImageItemDetailBuilder> {
  _$ImageItemDetail _$v;

  String _itemName;
  String get itemName => _$this._itemName;
  set itemName(String itemName) => _$this._itemName = itemName;

  String _x;
  String get x => _$this._x;
  set x(String x) => _$this._x = x;

  String _y;
  String get y => _$this._y;
  set y(String y) => _$this._y = y;

  String _height;
  String get height => _$this._height;
  set height(String height) => _$this._height = height;

  String _width;
  String get width => _$this._width;
  set width(String width) => _$this._width = width;

  ImageItemDetailBuilder();

  ImageItemDetailBuilder get _$this {
    if (_$v != null) {
      _itemName = _$v.itemName;
      _x = _$v.x;
      _y = _$v.y;
      _height = _$v.height;
      _width = _$v.width;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImageItemDetail other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ImageItemDetail;
  }

  @override
  void update(void Function(ImageItemDetailBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ImageItemDetail build() {
    final _$result = _$v ??
        new _$ImageItemDetail._(
            itemName: itemName, x: x, y: y, height: height, width: width);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
