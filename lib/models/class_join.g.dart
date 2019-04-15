// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_join.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ClassJoin> _$classJoinSerializer = new _$ClassJoinSerializer();

class _$ClassJoinSerializer implements StructuredSerializer<ClassJoin> {
  @override
  final Iterable<Type> types = const [ClassJoin, _$ClassJoin];
  @override
  final String wireName = 'ClassJoin';

  @override
  Iterable serialize(Serializers serializers, ClassJoin object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'studentId',
      serializers.serialize(object.studentId,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ClassJoin deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClassJoinBuilder();

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
        case 'studentId':
          result.studentId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ClassJoin extends ClassJoin {
  @override
  final String sessionId;
  @override
  final String studentId;

  factory _$ClassJoin([void updates(ClassJoinBuilder b)]) =>
      (new ClassJoinBuilder()..update(updates)).build();

  _$ClassJoin._({this.sessionId, this.studentId}) : super._() {
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('ClassJoin', 'sessionId');
    }
    if (studentId == null) {
      throw new BuiltValueNullFieldError('ClassJoin', 'studentId');
    }
  }

  @override
  ClassJoin rebuild(void updates(ClassJoinBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassJoinBuilder toBuilder() => new ClassJoinBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassJoin &&
        sessionId == other.sessionId &&
        studentId == other.studentId;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, sessionId.hashCode), studentId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassJoin')
          ..add('sessionId', sessionId)
          ..add('studentId', studentId))
        .toString();
  }
}

class ClassJoinBuilder implements Builder<ClassJoin, ClassJoinBuilder> {
  _$ClassJoin _$v;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  String _studentId;
  String get studentId => _$this._studentId;
  set studentId(String studentId) => _$this._studentId = studentId;

  ClassJoinBuilder();

  ClassJoinBuilder get _$this {
    if (_$v != null) {
      _sessionId = _$v.sessionId;
      _studentId = _$v.studentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassJoin other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClassJoin;
  }

  @override
  void update(void updates(ClassJoinBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassJoin build() {
    final _$result =
        _$v ?? new _$ClassJoin._(sessionId: sessionId, studentId: studentId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
