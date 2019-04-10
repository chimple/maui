// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'num_multi_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NumMultiData> _$numMultiDataSerializer =
    new _$NumMultiDataSerializer();

class _$NumMultiDataSerializer implements StructuredSerializer<NumMultiData> {
  @override
  final Iterable<Type> types = const [NumMultiData, _$NumMultiData];
  @override
  final String wireName = 'NumMultiData';

  @override
  Iterable serialize(Serializers serializers, NumMultiData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'answers',
      serializers.serialize(object.answers,
          specifiedType:
              const FullType(BuiltList, const [const FullType(int)])),
    ];
    if (object.question != null) {
      result
        ..add('question')
        ..add(serializers.serialize(object.question,
            specifiedType: const FullType(String)));
    }
    if (object.choices != null) {
      result
        ..add('choices')
        ..add(serializers.serialize(object.choices,
            specifiedType:
                const FullType(BuiltList, const [const FullType(int)])));
    }
    if (object.specials != null) {
      result
        ..add('specials')
        ..add(serializers.serialize(object.specials,
            specifiedType:
                const FullType(BuiltList, const [const FullType(int)])));
    }

    return result;
  }

  @override
  NumMultiData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NumMultiDataBuilder();

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
        case 'answers':
          result.answers.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))
              as BuiltList);
          break;
        case 'choices':
          result.choices.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))
              as BuiltList);
          break;
        case 'specials':
          result.specials.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$NumMultiData extends NumMultiData {
  @override
  final String gameId;
  @override
  final String question;
  @override
  final BuiltList<int> answers;
  @override
  final BuiltList<int> choices;
  @override
  final BuiltList<int> specials;

  factory _$NumMultiData([void updates(NumMultiDataBuilder b)]) =>
      (new NumMultiDataBuilder()..update(updates)).build();

  _$NumMultiData._(
      {this.gameId, this.question, this.answers, this.choices, this.specials})
      : super._() {
    if (gameId == null) {
      throw new BuiltValueNullFieldError('NumMultiData', 'gameId');
    }
    if (answers == null) {
      throw new BuiltValueNullFieldError('NumMultiData', 'answers');
    }
  }

  @override
  NumMultiData rebuild(void updates(NumMultiDataBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  NumMultiDataBuilder toBuilder() => new NumMultiDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NumMultiData &&
        gameId == other.gameId &&
        question == other.question &&
        answers == other.answers &&
        choices == other.choices &&
        specials == other.specials;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, gameId.hashCode), question.hashCode),
                answers.hashCode),
            choices.hashCode),
        specials.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NumMultiData')
          ..add('gameId', gameId)
          ..add('question', question)
          ..add('answers', answers)
          ..add('choices', choices)
          ..add('specials', specials))
        .toString();
  }
}

class NumMultiDataBuilder
    implements Builder<NumMultiData, NumMultiDataBuilder>, GameDataBuilder {
  _$NumMultiData _$v;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  String _question;
  String get question => _$this._question;
  set question(String question) => _$this._question = question;

  ListBuilder<int> _answers;
  ListBuilder<int> get answers => _$this._answers ??= new ListBuilder<int>();
  set answers(ListBuilder<int> answers) => _$this._answers = answers;

  ListBuilder<int> _choices;
  ListBuilder<int> get choices => _$this._choices ??= new ListBuilder<int>();
  set choices(ListBuilder<int> choices) => _$this._choices = choices;

  ListBuilder<int> _specials;
  ListBuilder<int> get specials => _$this._specials ??= new ListBuilder<int>();
  set specials(ListBuilder<int> specials) => _$this._specials = specials;

  NumMultiDataBuilder();

  NumMultiDataBuilder get _$this {
    if (_$v != null) {
      _gameId = _$v.gameId;
      _question = _$v.question;
      _answers = _$v.answers?.toBuilder();
      _choices = _$v.choices?.toBuilder();
      _specials = _$v.specials?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant NumMultiData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NumMultiData;
  }

  @override
  void update(void updates(NumMultiDataBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$NumMultiData build() {
    _$NumMultiData _$result;
    try {
      _$result = _$v ??
          new _$NumMultiData._(
              gameId: gameId,
              question: question,
              answers: answers.build(),
              choices: _choices?.build(),
              specials: _specials?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'answers';
        answers.build();
        _$failedField = 'choices';
        _choices?.build();
        _$failedField = 'specials';
        _specials?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'NumMultiData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
