// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_students.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ClassStudents> _$classStudentsSerializer =
    new _$ClassStudentsSerializer();

class _$ClassStudentsSerializer implements StructuredSerializer<ClassStudents> {
  @override
  final Iterable<Type> types = const [ClassStudents, _$ClassStudents];
  @override
  final String wireName = 'ClassStudents';

  @override
  Iterable serialize(Serializers serializers, ClassStudents object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'classId',
      serializers.serialize(object.classId,
          specifiedType: const FullType(String)),
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
      'students',
      serializers.serialize(object.students,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Student)])),
    ];

    return result;
  }

  @override
  ClassStudents deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClassStudentsBuilder();

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
        case 'sessionId':
          result.sessionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'students':
          result.students.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(Student)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ClassStudents extends ClassStudents {
  @override
  final String classId;
  @override
  final String sessionId;
  @override
  final BuiltList<Student> students;

  factory _$ClassStudents([void Function(ClassStudentsBuilder) updates]) =>
      (new ClassStudentsBuilder()..update(updates)).build();

  _$ClassStudents._({this.classId, this.sessionId, this.students}) : super._() {
    if (classId == null) {
      throw new BuiltValueNullFieldError('ClassStudents', 'classId');
    }
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('ClassStudents', 'sessionId');
    }
    if (students == null) {
      throw new BuiltValueNullFieldError('ClassStudents', 'students');
    }
  }

  @override
  ClassStudents rebuild(void Function(ClassStudentsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassStudentsBuilder toBuilder() => new ClassStudentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassStudents &&
        classId == other.classId &&
        sessionId == other.sessionId &&
        students == other.students;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, classId.hashCode), sessionId.hashCode), students.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassStudents')
          ..add('classId', classId)
          ..add('sessionId', sessionId)
          ..add('students', students))
        .toString();
  }
}

class ClassStudentsBuilder
    implements Builder<ClassStudents, ClassStudentsBuilder> {
  _$ClassStudents _$v;

  String _classId;
  String get classId => _$this._classId;
  set classId(String classId) => _$this._classId = classId;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  ListBuilder<Student> _students;
  ListBuilder<Student> get students =>
      _$this._students ??= new ListBuilder<Student>();
  set students(ListBuilder<Student> students) => _$this._students = students;

  ClassStudentsBuilder();

  ClassStudentsBuilder get _$this {
    if (_$v != null) {
      _classId = _$v.classId;
      _sessionId = _$v.sessionId;
      _students = _$v.students?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassStudents other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClassStudents;
  }

  @override
  void update(void Function(ClassStudentsBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassStudents build() {
    _$ClassStudents _$result;
    try {
      _$result = _$v ??
          new _$ClassStudents._(
              classId: classId,
              sessionId: sessionId,
              students: students.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'students';
        students.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ClassStudents', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
