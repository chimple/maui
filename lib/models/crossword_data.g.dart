// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crossword_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CrosswordData> _$crosswordDataSerializer =
    new _$CrosswordDataSerializer();
Serializer<ImageData> _$imageDataSerializer = new _$ImageDataSerializer();

class _$CrosswordDataSerializer implements StructuredSerializer<CrosswordData> {
  @override
  final Iterable<Type> types = const [CrosswordData, _$CrosswordData];
  @override
  final String wireName = 'CrosswordData';

  @override
  Iterable serialize(Serializers serializers, CrosswordData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'images',
      serializers.serialize(object.images,
          specifiedType:
              const FullType(BuiltList, const [const FullType(ImageData)])),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(BuiltList, const [
            const FullType(BuiltList, const [const FullType(String)])
          ])),
    ];

    return result;
  }

  @override
  CrosswordData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CrosswordDataBuilder();

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
        case 'images':
          result.images.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(ImageData)])) as BuiltList);
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(BuiltList, const [const FullType(String)])
              ])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ImageDataSerializer implements StructuredSerializer<ImageData> {
  @override
  final Iterable<Type> types = const [ImageData, _$ImageData];
  @override
  final String wireName = 'ImageData';

  @override
  Iterable serialize(Serializers serializers, ImageData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'image',
      serializers.serialize(object.image,
          specifiedType: const FullType(String)),
      'x',
      serializers.serialize(object.x, specifiedType: const FullType(int)),
      'y',
      serializers.serialize(object.y, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  ImageData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ImageDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'x':
          result.x = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'y':
          result.y = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$CrosswordData extends CrosswordData {
  @override
  final String gameId;
  @override
  final BuiltList<ImageData> images;
  @override
  final BuiltList<BuiltList<String>> data;

  factory _$CrosswordData([void Function(CrosswordDataBuilder) updates]) =>
      (new CrosswordDataBuilder()..update(updates)).build();

  _$CrosswordData._({this.gameId, this.images, this.data}) : super._() {
    if (gameId == null) {
      throw new BuiltValueNullFieldError('CrosswordData', 'gameId');
    }
    if (images == null) {
      throw new BuiltValueNullFieldError('CrosswordData', 'images');
    }
    if (data == null) {
      throw new BuiltValueNullFieldError('CrosswordData', 'data');
    }
  }

  @override
  CrosswordData rebuild(void Function(CrosswordDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CrosswordDataBuilder toBuilder() => new CrosswordDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CrosswordData &&
        gameId == other.gameId &&
        images == other.images &&
        data == other.data;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, gameId.hashCode), images.hashCode), data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CrosswordData')
          ..add('gameId', gameId)
          ..add('images', images)
          ..add('data', data))
        .toString();
  }
}

class CrosswordDataBuilder
    implements Builder<CrosswordData, CrosswordDataBuilder>, GameDataBuilder {
  _$CrosswordData _$v;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  ListBuilder<ImageData> _images;
  ListBuilder<ImageData> get images =>
      _$this._images ??= new ListBuilder<ImageData>();
  set images(ListBuilder<ImageData> images) => _$this._images = images;

  ListBuilder<BuiltList<String>> _data;
  ListBuilder<BuiltList<String>> get data =>
      _$this._data ??= new ListBuilder<BuiltList<String>>();
  set data(ListBuilder<BuiltList<String>> data) => _$this._data = data;

  CrosswordDataBuilder();

  CrosswordDataBuilder get _$this {
    if (_$v != null) {
      _gameId = _$v.gameId;
      _images = _$v.images?.toBuilder();
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant CrosswordData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CrosswordData;
  }

  @override
  void update(void Function(CrosswordDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CrosswordData build() {
    _$CrosswordData _$result;
    try {
      _$result = _$v ??
          new _$CrosswordData._(
              gameId: gameId, images: images.build(), data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'images';
        images.build();
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CrosswordData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ImageData extends ImageData {
  @override
  final String image;
  @override
  final int x;
  @override
  final int y;

  factory _$ImageData([void Function(ImageDataBuilder) updates]) =>
      (new ImageDataBuilder()..update(updates)).build();

  _$ImageData._({this.image, this.x, this.y}) : super._() {
    if (image == null) {
      throw new BuiltValueNullFieldError('ImageData', 'image');
    }
    if (x == null) {
      throw new BuiltValueNullFieldError('ImageData', 'x');
    }
    if (y == null) {
      throw new BuiltValueNullFieldError('ImageData', 'y');
    }
  }

  @override
  ImageData rebuild(void Function(ImageDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImageDataBuilder toBuilder() => new ImageDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImageData &&
        image == other.image &&
        x == other.x &&
        y == other.y;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, image.hashCode), x.hashCode), y.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ImageData')
          ..add('image', image)
          ..add('x', x)
          ..add('y', y))
        .toString();
  }
}

class ImageDataBuilder implements Builder<ImageData, ImageDataBuilder> {
  _$ImageData _$v;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  int _x;
  int get x => _$this._x;
  set x(int x) => _$this._x = x;

  int _y;
  int get y => _$this._y;
  set y(int y) => _$this._y = y;

  ImageDataBuilder();

  ImageDataBuilder get _$this {
    if (_$v != null) {
      _image = _$v.image;
      _x = _$v.x;
      _y = _$v.y;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImageData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ImageData;
  }

  @override
  void update(void Function(ImageDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ImageData build() {
    final _$result = _$v ?? new _$ImageData._(image: image, x: x, y: y);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
