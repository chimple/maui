// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Score> _$scoreSerializer = new _$ScoreSerializer();

class _$ScoreSerializer implements StructuredSerializer<Score> {
  @override
  final Iterable<Type> types = const [Score, _$Score];
  @override
  final String wireName = 'Score';

  @override
  Iterable serialize(Serializers serializers, Score object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'studentId',
      serializers.serialize(object.studentId,
          specifiedType: const FullType(String)),
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
      'max',
      serializers.serialize(object.max, specifiedType: const FullType(int)),
      'level',
      serializers.serialize(object.level, specifiedType: const FullType(int)),
      'startTime',
      serializers.serialize(object.startTime,
          specifiedType: const FullType(DateTime)),
      'endTime',
      serializers.serialize(object.endTime,
          specifiedType: const FullType(DateTime)),
    ];

    return result;
  }

  @override
  Score deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ScoreBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'studentId':
          result.studentId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gameId':
          result.gameId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sessionId':
          result.sessionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'max':
          result.max = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'level':
          result.level = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'startTime':
          result.startTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'endTime':
          result.endTime = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$Score extends Score {
  @override
  final String studentId;
  @override
  final String gameId;
  @override
  final String sessionId;
  @override
  final int score;
  @override
  final int max;
  @override
  final int level;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;

  factory _$Score([void Function(ScoreBuilder) updates]) =>
      (new ScoreBuilder()..update(updates)).build();

  _$Score._(
      {this.studentId,
      this.gameId,
      this.sessionId,
      this.score,
      this.max,
      this.level,
      this.startTime,
      this.endTime})
      : super._() {
    if (studentId == null) {
      throw new BuiltValueNullFieldError('Score', 'studentId');
    }
    if (gameId == null) {
      throw new BuiltValueNullFieldError('Score', 'gameId');
    }
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('Score', 'sessionId');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('Score', 'score');
    }
    if (max == null) {
      throw new BuiltValueNullFieldError('Score', 'max');
    }
    if (level == null) {
      throw new BuiltValueNullFieldError('Score', 'level');
    }
    if (startTime == null) {
      throw new BuiltValueNullFieldError('Score', 'startTime');
    }
    if (endTime == null) {
      throw new BuiltValueNullFieldError('Score', 'endTime');
    }
  }

  @override
  Score rebuild(void Function(ScoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScoreBuilder toBuilder() => new ScoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Score &&
        studentId == other.studentId &&
        gameId == other.gameId &&
        sessionId == other.sessionId &&
        score == other.score &&
        max == other.max &&
        level == other.level &&
        startTime == other.startTime &&
        endTime == other.endTime;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, studentId.hashCode), gameId.hashCode),
                            sessionId.hashCode),
                        score.hashCode),
                    max.hashCode),
                level.hashCode),
            startTime.hashCode),
        endTime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Score')
          ..add('studentId', studentId)
          ..add('gameId', gameId)
          ..add('sessionId', sessionId)
          ..add('score', score)
          ..add('max', max)
          ..add('level', level)
          ..add('startTime', startTime)
          ..add('endTime', endTime))
        .toString();
  }
}

class ScoreBuilder implements Builder<Score, ScoreBuilder> {
  _$Score _$v;

  String _studentId;
  String get studentId => _$this._studentId;
  set studentId(String studentId) => _$this._studentId = studentId;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  int _max;
  int get max => _$this._max;
  set max(int max) => _$this._max = max;

  int _level;
  int get level => _$this._level;
  set level(int level) => _$this._level = level;

  DateTime _startTime;
  DateTime get startTime => _$this._startTime;
  set startTime(DateTime startTime) => _$this._startTime = startTime;

  DateTime _endTime;
  DateTime get endTime => _$this._endTime;
  set endTime(DateTime endTime) => _$this._endTime = endTime;

  ScoreBuilder();

  ScoreBuilder get _$this {
    if (_$v != null) {
      _studentId = _$v.studentId;
      _gameId = _$v.gameId;
      _sessionId = _$v.sessionId;
      _score = _$v.score;
      _max = _$v.max;
      _level = _$v.level;
      _startTime = _$v.startTime;
      _endTime = _$v.endTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Score other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Score;
  }

  @override
  void update(void Function(ScoreBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Score build() {
    final _$result = _$v ??
        new _$Score._(
            studentId: studentId,
            gameId: gameId,
            sessionId: sessionId,
            score: score,
            max: max,
            level: level,
            startTime: startTime,
            endTime: endTime);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
