// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisplayTypeEnum _$letter = const DisplayTypeEnum._('letter');
const DisplayTypeEnum _$syllable = const DisplayTypeEnum._('syllable');
const DisplayTypeEnum _$word = const DisplayTypeEnum._('word');
const DisplayTypeEnum _$sentence = const DisplayTypeEnum._('sentence');
const DisplayTypeEnum _$image = const DisplayTypeEnum._('image');
const DisplayTypeEnum _$audio = const DisplayTypeEnum._('audio');

DisplayTypeEnum _$valueOf(String name) {
  switch (name) {
    case 'letter':
      return _$letter;
    case 'syllable':
      return _$syllable;
    case 'word':
      return _$word;
    case 'sentence':
      return _$sentence;
    case 'image':
      return _$image;
    case 'audio':
      return _$audio;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DisplayTypeEnum> _$values =
    new BuiltSet<DisplayTypeEnum>(const <DisplayTypeEnum>[
  _$letter,
  _$syllable,
  _$word,
  _$sentence,
  _$image,
  _$audio,
]);

Serializer<DisplayItem> _$displayItemSerializer = new _$DisplayItemSerializer();
Serializer<DisplayTypeEnum> _$displayTypeEnumSerializer =
    new _$DisplayTypeEnumSerializer();

class _$DisplayItemSerializer implements StructuredSerializer<DisplayItem> {
  @override
  final Iterable<Type> types = const [DisplayItem, _$DisplayItem];
  @override
  final String wireName = 'DisplayItem';

  @override
  Iterable serialize(Serializers serializers, DisplayItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'item',
      serializers.serialize(object.item, specifiedType: const FullType(String)),
      'displayType',
      serializers.serialize(object.displayType,
          specifiedType: const FullType(DisplayTypeEnum)),
    ];
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }
    if (object.audio != null) {
      result
        ..add('audio')
        ..add(serializers.serialize(object.audio,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  DisplayItem deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DisplayItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'item':
          result.item = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'displayType':
          result.displayType = serializers.deserialize(value,
                  specifiedType: const FullType(DisplayTypeEnum))
              as DisplayTypeEnum;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'audio':
          result.audio = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DisplayTypeEnumSerializer
    implements PrimitiveSerializer<DisplayTypeEnum> {
  @override
  final Iterable<Type> types = const <Type>[DisplayTypeEnum];
  @override
  final String wireName = 'DisplayTypeEnum';

  @override
  Object serialize(Serializers serializers, DisplayTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  DisplayTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisplayTypeEnum.valueOf(serialized as String);
}

class _$DisplayItem extends DisplayItem {
  @override
  final String item;
  @override
  final DisplayTypeEnum displayType;
  @override
  final String image;
  @override
  final String audio;

  factory _$DisplayItem([void Function(DisplayItemBuilder) updates]) =>
      (new DisplayItemBuilder()..update(updates)).build();

  _$DisplayItem._({this.item, this.displayType, this.image, this.audio})
      : super._() {
    if (item == null) {
      throw new BuiltValueNullFieldError('DisplayItem', 'item');
    }
    if (displayType == null) {
      throw new BuiltValueNullFieldError('DisplayItem', 'displayType');
    }
  }

  @override
  DisplayItem rebuild(void Function(DisplayItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisplayItemBuilder toBuilder() => new DisplayItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisplayItem &&
        item == other.item &&
        displayType == other.displayType &&
        image == other.image &&
        audio == other.audio;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, item.hashCode), displayType.hashCode), image.hashCode),
        audio.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DisplayItem')
          ..add('item', item)
          ..add('displayType', displayType)
          ..add('image', image)
          ..add('audio', audio))
        .toString();
  }
}

class DisplayItemBuilder implements Builder<DisplayItem, DisplayItemBuilder> {
  _$DisplayItem _$v;

  String _item;
  String get item => _$this._item;
  set item(String item) => _$this._item = item;

  DisplayTypeEnum _displayType;
  DisplayTypeEnum get displayType => _$this._displayType;
  set displayType(DisplayTypeEnum displayType) =>
      _$this._displayType = displayType;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _audio;
  String get audio => _$this._audio;
  set audio(String audio) => _$this._audio = audio;

  DisplayItemBuilder();

  DisplayItemBuilder get _$this {
    if (_$v != null) {
      _item = _$v.item;
      _displayType = _$v.displayType;
      _image = _$v.image;
      _audio = _$v.audio;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisplayItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DisplayItem;
  }

  @override
  void update(void Function(DisplayItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DisplayItem build() {
    final _$result = _$v ??
        new _$DisplayItem._(
            item: item, displayType: displayType, image: image, audio: audio);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
