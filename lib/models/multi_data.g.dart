// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MultiData> _$multiDataSerializer = new _$MultiDataSerializer();

class _$MultiDataSerializer implements StructuredSerializer<MultiData> {
  @override
  final Iterable<Type> types = const [MultiData, _$MultiData];
  @override
  final String wireName = 'MultiData';

  @override
  Iterable serialize(Serializers serializers, MultiData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'answers',
      serializers.serialize(object.answers,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.question != null) {
      result
        ..add('question')
        ..add(serializers.serialize(object.question,
            specifiedType: const FullType(String)));
    }
    if (object.specials != null) {
      result
        ..add('specials')
        ..add(serializers.serialize(object.specials,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    if (object.choices != null) {
      result
        ..add('choices')
        ..add(serializers.serialize(object.choices,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }

    return result;
  }

  @override
  MultiData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MultiDataBuilder();

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
        case 'question':
          result.question = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'specials':
          result.specials.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'choices':
          result.choices.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'answers':
          result.answers.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$MultiData extends MultiData {
  @override
  final String gameId;
  @override
  final String question;
  @override
  final BuiltList<String> specials;
  @override
  final BuiltList<String> choices;
  @override
  final BuiltList<String> answers;

  factory _$MultiData([void Function(MultiDataBuilder) updates]) =>
      (new MultiDataBuilder()..update(updates)).build();

  _$MultiData._(
      {this.gameId, this.question, this.specials, this.choices, this.answers})
      : super._() {
    if (gameId == null) {
      throw new BuiltValueNullFieldError('MultiData', 'gameId');
    }
    if (answers == null) {
      throw new BuiltValueNullFieldError('MultiData', 'answers');
    }
  }

  @override
  MultiData rebuild(void Function(MultiDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MultiDataBuilder toBuilder() => new MultiDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MultiData &&
        gameId == other.gameId &&
        question == other.question &&
        specials == other.specials &&
        choices == other.choices &&
        answers == other.answers;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, gameId.hashCode), question.hashCode),
                specials.hashCode),
            choices.hashCode),
        answers.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MultiData')
          ..add('gameId', gameId)
          ..add('question', question)
          ..add('specials', specials)
          ..add('choices', choices)
          ..add('answers', answers))
        .toString();
  }
}

class MultiDataBuilder
    implements Builder<MultiData, MultiDataBuilder>, GameDataBuilder {
  _$MultiData _$v;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  String _question;
  String get question => _$this._question;
  set question(String question) => _$this._question = question;

  ListBuilder<String> _specials;
  ListBuilder<String> get specials =>
      _$this._specials ??= new ListBuilder<String>();
  set specials(ListBuilder<String> specials) => _$this._specials = specials;

  ListBuilder<String> _choices;
  ListBuilder<String> get choices =>
      _$this._choices ??= new ListBuilder<String>();
  set choices(ListBuilder<String> choices) => _$this._choices = choices;

  ListBuilder<String> _answers;
  ListBuilder<String> get answers =>
      _$this._answers ??= new ListBuilder<String>();
  set answers(ListBuilder<String> answers) => _$this._answers = answers;

  MultiDataBuilder();

  MultiDataBuilder get _$this {
    if (_$v != null) {
      _gameId = _$v.gameId;
      _question = _$v.question;
      _specials = _$v.specials?.toBuilder();
      _choices = _$v.choices?.toBuilder();
      _answers = _$v.answers?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant MultiData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MultiData;
  }

  @override
  void update(void Function(MultiDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MultiData build() {
    _$MultiData _$result;
    try {
      _$result = _$v ??
          new _$MultiData._(
              gameId: gameId,
              question: question,
              specials: _specials?.build(),
              choices: _choices?.build(),
              answers: answers.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'specials';
        _specials?.build();
        _$failedField = 'choices';
        _choices?.build();
        _$failedField = 'answers';
        answers.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MultiData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
