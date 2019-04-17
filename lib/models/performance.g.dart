// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Performance> _$performanceSerializer = new _$PerformanceSerializer();

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
      'gameId',
      serializers.serialize(object.gameId,
          specifiedType: const FullType(String)),
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'level',
      serializers.serialize(object.level, specifiedType: const FullType(int)),
      'question',
      serializers.serialize(object.question,
          specifiedType: const FullType(String)),
      'answer',
      serializers.serialize(object.answer,
          specifiedType: const FullType(String)),
      'correct',
      serializers.serialize(object.correct,
          specifiedType: const FullType(bool)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
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
        case 'gameId':
          result.gameId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sessionId':
          result.sessionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'level':
          result.level = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'question':
          result.question = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'answer':
          result.answer = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'correct':
          result.correct = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'total':
          result.total = serializers.deserialize(value,
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
  final String gameId;
  @override
  final String sessionId;
  @override
  final int level;
  @override
  final String question;
  @override
  final String answer;
  @override
  final bool correct;
  @override
  final int score;
  @override
  final int total;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;

  factory _$Performance([void Function(PerformanceBuilder) updates]) =>
      (new PerformanceBuilder()..update(updates)).build();

  _$Performance._(
      {this.studentId,
      this.gameId,
      this.sessionId,
      this.level,
      this.question,
      this.answer,
      this.correct,
      this.score,
      this.total,
      this.startTime,
      this.endTime})
      : super._() {
    if (studentId == null) {
      throw new BuiltValueNullFieldError('Performance', 'studentId');
    }
    if (gameId == null) {
      throw new BuiltValueNullFieldError('Performance', 'gameId');
    }
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('Performance', 'sessionId');
    }
    if (level == null) {
      throw new BuiltValueNullFieldError('Performance', 'level');
    }
    if (question == null) {
      throw new BuiltValueNullFieldError('Performance', 'question');
    }
    if (answer == null) {
      throw new BuiltValueNullFieldError('Performance', 'answer');
    }
    if (correct == null) {
      throw new BuiltValueNullFieldError('Performance', 'correct');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('Performance', 'score');
    }
    if (total == null) {
      throw new BuiltValueNullFieldError('Performance', 'total');
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
        gameId == other.gameId &&
        sessionId == other.sessionId &&
        level == other.level &&
        question == other.question &&
        answer == other.answer &&
        correct == other.correct &&
        score == other.score &&
        total == other.total &&
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
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, studentId.hashCode),
                                            gameId.hashCode),
                                        sessionId.hashCode),
                                    level.hashCode),
                                question.hashCode),
                            answer.hashCode),
                        correct.hashCode),
                    score.hashCode),
                total.hashCode),
            startTime.hashCode),
        endTime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Performance')
          ..add('studentId', studentId)
          ..add('gameId', gameId)
          ..add('sessionId', sessionId)
          ..add('level', level)
          ..add('question', question)
          ..add('answer', answer)
          ..add('correct', correct)
          ..add('score', score)
          ..add('total', total)
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

  String _gameId;
  String get gameId => _$this._gameId;
  set gameId(String gameId) => _$this._gameId = gameId;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  int _level;
  int get level => _$this._level;
  set level(int level) => _$this._level = level;

  String _question;
  String get question => _$this._question;
  set question(String question) => _$this._question = question;

  String _answer;
  String get answer => _$this._answer;
  set answer(String answer) => _$this._answer = answer;

  bool _correct;
  bool get correct => _$this._correct;
  set correct(bool correct) => _$this._correct = correct;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  int _total;
  int get total => _$this._total;
  set total(int total) => _$this._total = total;

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
      _gameId = _$v.gameId;
      _sessionId = _$v.sessionId;
      _level = _$v.level;
      _question = _$v.question;
      _answer = _$v.answer;
      _correct = _$v.correct;
      _score = _$v.score;
      _total = _$v.total;
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
    final _$result = _$v ??
        new _$Performance._(
            studentId: studentId,
            gameId: gameId,
            sessionId: sessionId,
            level: level,
            question: question,
            answer: answer,
            correct: correct,
            score: score,
            total: total,
            startTime: startTime,
            endTime: endTime);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
