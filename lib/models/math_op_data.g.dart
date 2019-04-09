// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'math_op_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MathOpData> _$mathOpDataSerializer = new _$MathOpDataSerializer();

class _$MathOpDataSerializer implements StructuredSerializer<MathOpData> {
  @override
  final Iterable<Type> types = const [MathOpData, _$MathOpData];
  @override
  final String wireName = 'MathOpData';

  @override
  Iterable serialize(Serializers serializers, MathOpData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'first',
      serializers.serialize(object.first, specifiedType: const FullType(int)),
      'second',
      serializers.serialize(object.second, specifiedType: const FullType(int)),
      'op',
      serializers.serialize(object.op, specifiedType: const FullType(String)),
      'answer',
      serializers.serialize(object.answer, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  MathOpData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MathOpDataBuilder();

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
        case 'first':
          result.first = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'second':
          result.second = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'op':
          result.op = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'answer':
          result.answer = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$MathOpData extends MathOpData {
  @override
  final String gameId;
  @override
  final int first;
  @override
  final int second;
  @override
  final String op;
  @override
  final int answer;

  factory _$MathOpData([void updates(MathOpDataBuilder b)]) =>
      (new MathOpDataBuilder()..update(updates)).build();

  _$MathOpData._({this.gameId, this.first, this.second, this.op, this.answer})
      : super._() {
    if (gameId == null) {
      throw new BuiltValueNullFieldError('MathOpData', 'gameId');
    }
    if (first == null) {
      throw new BuiltValueNullFieldError('MathOpData', 'first');
    }
    if (second == null) {
      throw new BuiltValueNullFieldError('MathOpData', 'second');
    }
    if (op == null) {
      throw new BuiltValueNullFieldError('MathOpData', 'op');
    }
    if (answer == null) {
      throw new BuiltValueNullFieldError('MathOpData', 'answer');
    }
  }

  @override
  MathOpData rebuild(void updates(MathOpDataBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  MathOpDataBuilder toBuilder() => new MathOpDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MathOpData &&
        gameId == other.gameId &&
        first == other.first &&
        second == other.second &&
        op == other.op &&
        answer == other.answer;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, gameId.hashCode), first.hashCode), second.hashCode),
            op.hashCode),
        answer.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MathOpData')
          ..add('gameId', gameId)
          ..add('first', first)
          ..add('second', second)
          ..add('op', op)
          ..add('answer', answer))
        .toString();
  }
}

class MathOpDataBuilder
    implements Builder<MathOpData, MathOpDataBuilder>, GameDataBuilder {
  _$MathOpData _$v;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  int _first;
  int get first => _$this._first;
  set first(int first) => _$this._first = first;

  int _second;
  int get second => _$this._second;
  set second(int second) => _$this._second = second;

  String _op;
  String get op => _$this._op;
  set op(String op) => _$this._op = op;

  int _answer;
  int get answer => _$this._answer;
  set answer(int answer) => _$this._answer = answer;

  MathOpDataBuilder();

  MathOpDataBuilder get _$this {
    if (_$v != null) {
      _gameId = _$v.gameId;
      _first = _$v.first;
      _second = _$v.second;
      _op = _$v.op;
      _answer = _$v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant MathOpData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MathOpData;
  }

  @override
  void update(void updates(MathOpDataBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$MathOpData build() {
    final _$result = _$v ??
        new _$MathOpData._(
            gameId: gameId,
            first: first,
            second: second,
            op: op,
            answer: answer);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
