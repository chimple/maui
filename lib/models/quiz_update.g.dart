// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StatusEnum _$create = const StatusEnum._('create');
const StatusEnum _$start = const StatusEnum._('start');
const StatusEnum _$progress = const StatusEnum._('progress');
const StatusEnum _$end = const StatusEnum._('end');

StatusEnum _$valueOf(String name) {
  switch (name) {
    case 'create':
      return _$create;
    case 'start':
      return _$start;
    case 'progress':
      return _$progress;
    case 'end':
      return _$end;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<StatusEnum> _$values =
    new BuiltSet<StatusEnum>(const <StatusEnum>[
  _$create,
  _$start,
  _$progress,
  _$end,
]);

Serializer<QuizUpdate> _$quizUpdateSerializer = new _$QuizUpdateSerializer();
Serializer<StatusEnum> _$statusEnumSerializer = new _$StatusEnumSerializer();

class _$QuizUpdateSerializer implements StructuredSerializer<QuizUpdate> {
  @override
  final Iterable<Type> types = const [QuizUpdate, _$QuizUpdate];
  @override
  final String wireName = 'QuizUpdate';

  @override
  Iterable serialize(Serializers serializers, QuizUpdate object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(StatusEnum)),
    ];
    if (object.performances != null) {
      result
        ..add('performances')
        ..add(serializers.serialize(object.performances,
            specifiedType: const FullType(
                BuiltList, const [const FullType(Performance)])));
    }

    return result;
  }

  @override
  QuizUpdate deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new QuizUpdateBuilder();

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
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(StatusEnum)) as StatusEnum;
          break;
        case 'performances':
          result.performances.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Performance)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$StatusEnumSerializer implements PrimitiveSerializer<StatusEnum> {
  @override
  final Iterable<Type> types = const <Type>[StatusEnum];
  @override
  final String wireName = 'StatusEnum';

  @override
  Object serialize(Serializers serializers, StatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  StatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StatusEnum.valueOf(serialized as String);
}

class _$QuizUpdate extends QuizUpdate {
  @override
  final String sessionId;
  @override
  final StatusEnum status;
  @override
  final BuiltList<Performance> performances;

  factory _$QuizUpdate([void Function(QuizUpdateBuilder) updates]) =>
      (new QuizUpdateBuilder()..update(updates)).build();

  _$QuizUpdate._({this.sessionId, this.status, this.performances}) : super._() {
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('QuizUpdate', 'sessionId');
    }
    if (status == null) {
      throw new BuiltValueNullFieldError('QuizUpdate', 'status');
    }
  }

  @override
  QuizUpdate rebuild(void Function(QuizUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QuizUpdateBuilder toBuilder() => new QuizUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QuizUpdate &&
        sessionId == other.sessionId &&
        status == other.status &&
        performances == other.performances;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, sessionId.hashCode), status.hashCode),
        performances.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('QuizUpdate')
          ..add('sessionId', sessionId)
          ..add('status', status)
          ..add('performances', performances))
        .toString();
  }
}

class QuizUpdateBuilder implements Builder<QuizUpdate, QuizUpdateBuilder> {
  _$QuizUpdate _$v;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  StatusEnum _status;
  StatusEnum get status => _$this._status;
  set status(StatusEnum status) => _$this._status = status;

  ListBuilder<Performance> _performances;
  ListBuilder<Performance> get performances =>
      _$this._performances ??= new ListBuilder<Performance>();
  set performances(ListBuilder<Performance> performances) =>
      _$this._performances = performances;

  QuizUpdateBuilder();

  QuizUpdateBuilder get _$this {
    if (_$v != null) {
      _sessionId = _$v.sessionId;
      _status = _$v.status;
      _performances = _$v.performances?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QuizUpdate other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$QuizUpdate;
  }

  @override
  void update(void Function(QuizUpdateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$QuizUpdate build() {
    _$QuizUpdate _$result;
    try {
      _$result = _$v ??
          new _$QuizUpdate._(
              sessionId: sessionId,
              status: status,
              performances: _performances?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'performances';
        _performances?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'QuizUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
