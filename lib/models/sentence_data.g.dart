// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SentenceData> _$sentenceDataSerializer =
    new _$SentenceDataSerializer();
Serializer<WordWithImage> _$wordWithImageSerializer =
    new _$WordWithImageSerializer();

class _$SentenceDataSerializer implements StructuredSerializer<SentenceData> {
  @override
  final Iterable<Type> types = const [SentenceData, _$SentenceData];
  @override
  final String wireName = 'SentenceData';

  @override
  Iterable serialize(Serializers serializers, SentenceData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'wordWithImages',
      serializers.serialize(object.wordWithImages,
          specifiedType:
              const FullType(BuiltList, const [const FullType(WordWithImage)])),
      'headers',
      serializers.serialize(object.headers,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  SentenceData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SentenceDataBuilder();

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
        case 'wordWithImages':
          result.wordWithImages.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(WordWithImage)]))
              as BuiltList);
          break;
        case 'headers':
          result.headers.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$WordWithImageSerializer implements StructuredSerializer<WordWithImage> {
  @override
  final Iterable<Type> types = const [WordWithImage, _$WordWithImage];
  @override
  final String wireName = 'WordWithImage';

  @override
  Iterable serialize(Serializers serializers, WordWithImage object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'word',
      serializers.serialize(object.word, specifiedType: const FullType(String)),
    ];
    if (object.image != null) {
      result
        ..add('image')
        ..add(serializers.serialize(object.image,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  WordWithImage deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WordWithImageBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'word':
          result.word = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SentenceData extends SentenceData {
  @override
  final String gameId;
  @override
  final BuiltList<WordWithImage> wordWithImages;
  @override
  final BuiltList<String> headers;

  factory _$SentenceData([void Function(SentenceDataBuilder) updates]) =>
      (new SentenceDataBuilder()..update(updates)).build();

  _$SentenceData._({this.gameId, this.wordWithImages, this.headers})
      : super._() {
    if (gameId == null) {
      throw new BuiltValueNullFieldError('SentenceData', 'gameId');
    }
    if (wordWithImages == null) {
      throw new BuiltValueNullFieldError('SentenceData', 'wordWithImages');
    }
    if (headers == null) {
      throw new BuiltValueNullFieldError('SentenceData', 'headers');
    }
  }

  @override
  SentenceData rebuild(void Function(SentenceDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SentenceDataBuilder toBuilder() => new SentenceDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SentenceData &&
        gameId == other.gameId &&
        wordWithImages == other.wordWithImages &&
        headers == other.headers;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, gameId.hashCode), wordWithImages.hashCode),
        headers.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SentenceData')
          ..add('gameId', gameId)
          ..add('wordWithImages', wordWithImages)
          ..add('headers', headers))
        .toString();
  }
}

class SentenceDataBuilder
    implements Builder<SentenceData, SentenceDataBuilder>, GameDataBuilder {
  _$SentenceData _$v;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  ListBuilder<WordWithImage> _wordWithImages;
  ListBuilder<WordWithImage> get wordWithImages =>
      _$this._wordWithImages ??= new ListBuilder<WordWithImage>();
  set wordWithImages(ListBuilder<WordWithImage> wordWithImages) =>
      _$this._wordWithImages = wordWithImages;

  ListBuilder<String> _headers;
  ListBuilder<String> get headers =>
      _$this._headers ??= new ListBuilder<String>();
  set headers(ListBuilder<String> headers) => _$this._headers = headers;

  SentenceDataBuilder();

  SentenceDataBuilder get _$this {
    if (_$v != null) {
      _gameId = _$v.gameId;
      _wordWithImages = _$v.wordWithImages?.toBuilder();
      _headers = _$v.headers?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant SentenceData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SentenceData;
  }

  @override
  void update(void Function(SentenceDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SentenceData build() {
    _$SentenceData _$result;
    try {
      _$result = _$v ??
          new _$SentenceData._(
              gameId: gameId,
              wordWithImages: wordWithImages.build(),
              headers: headers.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'wordWithImages';
        wordWithImages.build();
        _$failedField = 'headers';
        headers.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SentenceData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$WordWithImage extends WordWithImage {
  @override
  final String word;
  @override
  final String image;

  factory _$WordWithImage([void Function(WordWithImageBuilder) updates]) =>
      (new WordWithImageBuilder()..update(updates)).build();

  _$WordWithImage._({this.word, this.image}) : super._() {
    if (word == null) {
      throw new BuiltValueNullFieldError('WordWithImage', 'word');
    }
  }

  @override
  WordWithImage rebuild(void Function(WordWithImageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WordWithImageBuilder toBuilder() => new WordWithImageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WordWithImage && word == other.word && image == other.image;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, word.hashCode), image.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('WordWithImage')
          ..add('word', word)
          ..add('image', image))
        .toString();
  }
}

class WordWithImageBuilder
    implements Builder<WordWithImage, WordWithImageBuilder> {
  _$WordWithImage _$v;

  String _word;
  String get word => _$this._word;
  set word(String word) => _$this._word = word;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  WordWithImageBuilder();

  WordWithImageBuilder get _$this {
    if (_$v != null) {
      _word = _$v.word;
      _image = _$v.image;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WordWithImage other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$WordWithImage;
  }

  @override
  void update(void Function(WordWithImageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$WordWithImage build() {
    final _$result = _$v ?? new _$WordWithImage._(word: word, image: image);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
