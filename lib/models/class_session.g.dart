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
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'teacherName',
      serializers.serialize(object.teacherName,
          specifiedType: const FullType(String)),
      'teacherPhoto',
      serializers.serialize(object.teacherPhoto,
          specifiedType: const FullType(String)),
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
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
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'teacherName':
          result.teacherName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'teacherPhoto':
          result.teacherPhoto = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sessionId':
          result.sessionId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
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
  final String name;
  @override
  final String teacherName;
  @override
  final String teacherPhoto;
  @override
  final String sessionId;

  factory _$ClassSession([void updates(ClassSessionBuilder b)]) =>
      (new ClassSessionBuilder()..update(updates)).build();

  _$ClassSession._(
      {this.classId,
      this.name,
      this.teacherName,
      this.teacherPhoto,
      this.sessionId})
      : super._() {
    if (classId == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'classId');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'name');
    }
    if (teacherName == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'teacherName');
    }
    if (teacherPhoto == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'teacherPhoto');
    }
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('ClassSession', 'sessionId');
    }
  }

  @override
  ClassSession rebuild(void updates(ClassSessionBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassSessionBuilder toBuilder() => new ClassSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassSession &&
        classId == other.classId &&
        name == other.name &&
        teacherName == other.teacherName &&
        teacherPhoto == other.teacherPhoto &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, classId.hashCode), name.hashCode),
                teacherName.hashCode),
            teacherPhoto.hashCode),
        sessionId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassSession')
          ..add('classId', classId)
          ..add('name', name)
          ..add('teacherName', teacherName)
          ..add('teacherPhoto', teacherPhoto)
          ..add('sessionId', sessionId))
        .toString();
  }
}

class ClassSessionBuilder
    implements Builder<ClassSession, ClassSessionBuilder> {
  _$ClassSession _$v;

  String _classId;
  String get classId => _$this._classId;
  set classId(String classId) => _$this._classId = classId;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _teacherName;
  String get teacherName => _$this._teacherName;
  set teacherName(String teacherName) => _$this._teacherName = teacherName;

  String _teacherPhoto;
  String get teacherPhoto => _$this._teacherPhoto;
  set teacherPhoto(String teacherPhoto) => _$this._teacherPhoto = teacherPhoto;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  ClassSessionBuilder();

  ClassSessionBuilder get _$this {
    if (_$v != null) {
      _classId = _$v.classId;
      _name = _$v.name;
      _teacherName = _$v.teacherName;
      _teacherPhoto = _$v.teacherPhoto;
      _sessionId = _$v.sessionId;
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
  void update(void updates(ClassSessionBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassSession build() {
    final _$result = _$v ??
        new _$ClassSession._(
            classId: classId,
            name: name,
            teacherName: teacherName,
            teacherPhoto: teacherPhoto,
            sessionId: sessionId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
