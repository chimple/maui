// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ClassSession> _$classSessionSerializer =
    new _$ClassSessionSerializer();

class _$ClassSessionSerializer implements StructuredSerializer<ClassSession> {
  @override
  final Iterable<Type> types = const [ClassSession, _$ClassSession];
  @override
  final String wireName = 'ClassSession';

  @override
  Iterable serialize(Serializers serializers, ClassSession object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'classId',
      serializers.serialize(object.classId,
          specifiedType: const FullType(String)),
      'teacherId',
      serializers.serialize(object.teacherId,
          specifiedType: const FullType(String)),
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(StatusEnum)),
    ];

    return result;
  }

  @override
  ClassSession deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClassSessionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'classId':
          result.classId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'teacherId':
          result.teacherId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sessionId':
          result.sessionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(StatusEnum)) as StatusEnum;
          break;
      }
    }

    return result.build();
  }
}

class _$ClassSession extends ClassSession {
  @override
  final String classId;
  @override
  final String teacherId;
  @override
  final String sessionId;
  @override
  final StatusEnum status;

  factory _$ClassSession([void Function(ClassSessionBuilder) updates]) =>
      (new ClassSessionBuilder()..update(updates)).build();

  _$ClassSession._({this.classId, this.teacherId, this.sessionId, this.status})
      : super._() {
    if (classId == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'classId');
    }
    if (teacherId == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'teacherId');
    }
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'sessionId');
    }
    if (status == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'status');
    }
  }

  @override
  ClassSession rebuild(void Function(ClassSessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassSessionBuilder toBuilder() => new ClassSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassSession &&
        classId == other.classId &&
        teacherId == other.teacherId &&
        sessionId == other.sessionId &&
        status == other.status;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, classId.hashCode), teacherId.hashCode),
            sessionId.hashCode),
        status.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassSession')
          ..add('classId', classId)
          ..add('teacherId', teacherId)
          ..add('sessionId', sessionId)
          ..add('status', status))
        .toString();
  }
}

class ClassSessionBuilder
    implements Builder<ClassSession, ClassSessionBuilder> {
  _$ClassSession _$v;

  String _classId;
  String get classId => _$this._classId;
  set classId(String classId) => _$this._classId = classId;

  String _teacherId;
  String get teacherId => _$this._teacherId;
  set teacherId(String teacherId) => _$this._teacherId = teacherId;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  StatusEnum _status;
  StatusEnum get status => _$this._status;
  set status(StatusEnum status) => _$this._status = status;

  ClassSessionBuilder();

  ClassSessionBuilder get _$this {
    if (_$v != null) {
      _classId = _$v.classId;
      _teacherId = _$v.teacherId;
      _sessionId = _$v.sessionId;
      _status = _$v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassSession other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClassSession;
  }

  @override
  void update(void Function(ClassSessionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassSession build() {
    final _$result = _$v ??
        new _$ClassSession._(
            classId: classId,
            teacherId: teacherId,
            sessionId: sessionId,
            status: status);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
