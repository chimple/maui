// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Performance> _$performanceSerializer = new _$PerformanceSerializer();
Serializer<SubScore> _$subScoreSerializer = new _$SubScoreSerializer();

class _$PerformanceSerializer implements StructuredSerializer<Performance> {
  @override
  final Iterable<Type> types = const [Performance, _$Performance];
  @override
  final String wireName = 'Performance';

  @override
  Iterable serialize(Serializers serializers, Performance object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'studentId',
      serializers.serialize(object.studentId,
          specifiedType: const FullType(String)),
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'numGames',
      serializers.serialize(object.numGames,
          specifiedType: const FullType(int)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
      'subScores',
      serializers.serialize(object.subScores,
          specifiedType:
              const FullType(BuiltList, const [const FullType(SubScore)])),
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
  Performance deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PerformanceBuilder();

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
        case 'sessionId':
          result.sessionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'numGames':
          result.numGames = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'subScores':
          result.subScores.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(SubScore)])) as BuiltList);
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

class _$SubScoreSerializer implements StructuredSerializer<SubScore> {
  @override
  final Iterable<Type> types = const [SubScore, _$SubScore];
  @override
  final String wireName = 'SubScore';

  @override
  Iterable serialize(Serializers serializers, SubScore object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'complete',
      serializers.serialize(object.complete,
          specifiedType: const FullType(bool)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
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
  SubScore deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SubScoreBuilder();

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
        case 'complete':
          result.complete = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
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

class _$Performance extends Performance {
  @override
  final String studentId;
  @override
  final String sessionId;
  @override
  final String title;
  @override
  final int numGames;
  @override
  final int score;
  @override
  final BuiltList<SubScore> subScores;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;

  factory _$Performance([void Function(PerformanceBuilder) updates]) =>
      (new PerformanceBuilder()..update(updates)).build();

  _$Performance._(
      {this.studentId,
      this.sessionId,
      this.title,
      this.numGames,
      this.score,
      this.subScores,
      this.startTime,
      this.endTime})
      : super._() {
    if (studentId == null) {
      throw new BuiltValueNullFieldError('Performance', 'studentId');
    }
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('Performance', 'sessionId');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('Performance', 'title');
    }
    if (numGames == null) {
      throw new BuiltValueNullFieldError('Performance', 'numGames');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('Performance', 'score');
    }
    if (subScores == null) {
      throw new BuiltValueNullFieldError('Performance', 'subScores');
    }
    if (startTime == null) {
      throw new BuiltValueNullFieldError('Performance', 'startTime');
    }
    if (endTime == null) {
      throw new BuiltValueNullFieldError('Performance', 'endTime');
    }
  }

  @override
  Performance rebuild(void Function(PerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PerformanceBuilder toBuilder() => new PerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Performance &&
        studentId == other.studentId &&
        sessionId == other.sessionId &&
        title == other.title &&
        numGames == other.numGames &&
        score == other.score &&
        subScores == other.subScores &&
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
                        $jc($jc($jc(0, studentId.hashCode), sessionId.hashCode),
                            title.hashCode),
                        numGames.hashCode),
                    score.hashCode),
                subScores.hashCode),
            startTime.hashCode),
        endTime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Performance')
          ..add('studentId', studentId)
          ..add('sessionId', sessionId)
          ..add('title', title)
          ..add('numGames', numGames)
          ..add('score', score)
          ..add('subScores', subScores)
          ..add('startTime', startTime)
          ..add('endTime', endTime))
        .toString();
  }
}

class PerformanceBuilder implements Builder<Performance, PerformanceBuilder> {
  _$Performance _$v;

  String _studentId;
  String get studentId => _$this._studentId;
  set studentId(String studentId) => _$this._studentId = studentId;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  int _numGames;
  int get numGames => _$this._numGames;
  set numGames(int numGames) => _$this._numGames = numGames;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  ListBuilder<SubScore> _subScores;
  ListBuilder<SubScore> get subScores =>
      _$this._subScores ??= new ListBuilder<SubScore>();
  set subScores(ListBuilder<SubScore> subScores) =>
      _$this._subScores = subScores;

  DateTime _startTime;
  DateTime get startTime => _$this._startTime;
  set startTime(DateTime startTime) => _$this._startTime = startTime;

  DateTime _endTime;
  DateTime get endTime => _$this._endTime;
  set endTime(DateTime endTime) => _$this._endTime = endTime;

  PerformanceBuilder();

  PerformanceBuilder get _$this {
    if (_$v != null) {
      _studentId = _$v.studentId;
      _sessionId = _$v.sessionId;
      _title = _$v.title;
      _numGames = _$v.numGames;
      _score = _$v.score;
      _subScores = _$v.subScores?.toBuilder();
      _startTime = _$v.startTime;
      _endTime = _$v.endTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Performance other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Performance;
  }

  @override
  void update(void Function(PerformanceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Performance build() {
    _$Performance _$result;
    try {
      _$result = _$v ??
          new _$Performance._(
              studentId: studentId,
              sessionId: sessionId,
              title: title,
              numGames: numGames,
              score: score,
              subScores: subScores.build(),
              startTime: startTime,
              endTime: endTime);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'subScores';
        subScores.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Performance', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SubScore extends SubScore {
  @override
  final String gameId;
  @override
  final bool complete;
  @override
  final int score;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;

  factory _$SubScore([void Function(SubScoreBuilder) updates]) =>
      (new SubScoreBuilder()..update(updates)).build();

  _$SubScore._(
      {this.gameId, this.complete, this.score, this.startTime, this.endTime})
      : super._() {
    if (gameId == null) {
      throw new BuiltValueNullFieldError('SubScore', 'gameId');
    }
    if (complete == null) {
      throw new BuiltValueNullFieldError('SubScore', 'complete');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('SubScore', 'score');
    }
    if (startTime == null) {
      throw new BuiltValueNullFieldError('SubScore', 'startTime');
    }
    if (endTime == null) {
      throw new BuiltValueNullFieldError('SubScore', 'endTime');
    }
  }

  @override
  SubScore rebuild(void Function(SubScoreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubScoreBuilder toBuilder() => new SubScoreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubScore &&
        gameId == other.gameId &&
        complete == other.complete &&
        score == other.score &&
        startTime == other.startTime &&
        endTime == other.endTime;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, gameId.hashCode), complete.hashCode),
                score.hashCode),
            startTime.hashCode),
        endTime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SubScore')
          ..add('gameId', gameId)
          ..add('complete', complete)
          ..add('score', score)
          ..add('startTime', startTime)
          ..add('endTime', endTime))
        .toString();
  }
}

class SubScoreBuilder implements Builder<SubScore, SubScoreBuilder> {
  _$SubScore _$v;

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  bool _complete;
  bool get complete => _$this._complete;
  set complete(bool complete) => _$this._complete = complete;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  DateTime _startTime;
  DateTime get startTime => _$this._startTime;
  set startTime(DateTime startTime) => _$this._startTime = startTime;

  DateTime _endTime;
  DateTime get endTime => _$this._endTime;
  set endTime(DateTime endTime) => _$this._endTime = endTime;

  SubScoreBuilder();

  SubScoreBuilder get _$this {
    if (_$v != null) {
      _gameId = _$v.gameId;
      _complete = _$v.complete;
      _score = _$v.score;
      _startTime = _$v.startTime;
      _endTime = _$v.endTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubScore other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SubScore;
  }

  @override
  void update(void Function(SubScoreBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SubScore build() {
    final _$result = _$v ??
        new _$SubScore._(
            gameId: gameId,
            complete: complete,
            score: score,
            startTime: startTime,
            endTime: endTime);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
