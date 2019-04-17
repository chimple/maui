// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<QuizSession> _$quizSessionSerializer = new _$QuizSessionSerializer();

class _$QuizSessionSerializer implements StructuredSerializer<QuizSession> {
  @override
  final Iterable<Type> types = const [QuizSession, _$QuizSession];
  @override
  final String wireName = 'QuizSession';

  @override
  Iterable serialize(Serializers serializers, QuizSession object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'level',
      serializers.serialize(object.level, specifiedType: const FullType(int)),
      'gameData',
      serializers.serialize(object.gameData,
          specifiedType:
              const FullType(BuiltList, const [const FullType(GameData)])),
    ];

    return result;
  }

  @override
  QuizSession deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new QuizSessionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'sessionId':
          result.sessionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gameId':
          result.gameId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'level':
          result.level = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'gameData':
          result.gameData.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(GameData)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$QuizSession extends QuizSession {
  @override
  final String sessionId;
  @override
  final String gameId;
  @override
  final int level;
  @override
  final BuiltList<GameData> gameData;

  factory _$QuizSession([void Function(QuizSessionBuilder) updates]) =>
      (new QuizSessionBuilder()..update(updates)).build();

  _$QuizSession._({this.sessionId, this.gameId, this.level, this.gameData})
      : super._() {
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('QuizSession', 'sessionId');
    }
    if (gameId == null) {
      throw new BuiltValueNullFieldError('QuizSession', 'gameId');
    }
    if (level == null) {
      throw new BuiltValueNullFieldError('QuizSession', 'level');
    }
    if (gameData == null) {
      throw new BuiltValueNullFieldError('QuizSession', 'gameData');
    }
  }

  @override
  QuizSession rebuild(void Function(QuizSessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuizSessionBuilder toBuilder() => new QuizSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuizSession &&
        sessionId == other.sessionId &&
        gameId == other.gameId &&
        level == other.level &&
        gameData == other.gameData;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, sessionId.hashCode), gameId.hashCode), level.hashCode),
        gameData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('QuizSession')
          ..add('sessionId', sessionId)
          ..add('gameId', gameId)
          ..add('level', level)
          ..add('gameData', gameData))
        .toString();
  }
}

class QuizSessionBuilder implements Builder<QuizSession, QuizSessionBuilder> {
  _$QuizSession _$v;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  int _level;
  int get level => _$this._level;
  set level(int level) => _$this._level = level;

  ListBuilder<GameData> _gameData;
  ListBuilder<GameData> get gameData =>
      _$this._gameData ??= new ListBuilder<GameData>();
  set gameData(ListBuilder<GameData> gameData) => _$this._gameData = gameData;

  QuizSessionBuilder();

  QuizSessionBuilder get _$this {
    if (_$v != null) {
      _sessionId = _$v.sessionId;
      _gameId = _$v.gameId;
      _level = _$v.level;
      _gameData = _$v.gameData?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuizSession other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$QuizSession;
  }

  @override
  void update(void Function(QuizSessionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$QuizSession build() {
    _$QuizSession _$result;
    try {
      _$result = _$v ??
          new _$QuizSession._(
              sessionId: sessionId,
              gameId: gameId,
              level: level,
              gameData: gameData.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'gameData';
        gameData.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'QuizSession', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
