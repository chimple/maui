// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Student> _$studentSerializer = new _$StudentSerializer();

class _$StudentSerializer implements StructuredSerializer<Student> {
  @override
  final Iterable<Type> types = const [Student, _$Student];
  @override
  final String wireName = 'Student';

  @override
  Iterable serialize(Serializers serializers, Student object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'grade',
      serializers.serialize(object.grade,
          specifiedType: const FullType(String)),
      'photo',
      serializers.serialize(object.photo,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Student deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StudentBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'grade':
          result.grade = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'photo':
          result.photo = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Student extends Student {
  @override
  final String id;
  @override
  final String name;
  @override
  final String grade;
  @override
  final String photo;

  factory _$Student([void updates(StudentBuilder b)]) =>
      (new StudentBuilder()..update(updates)).build();

  _$Student._({this.id, this.name, this.grade, this.photo}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Student', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Student', 'name');
    }
    if (grade == null) {
      throw new BuiltValueNullFieldError('Student', 'grade');
    }
    if (photo == null) {
      throw new BuiltValueNullFieldError('Student', 'photo');
    }
  }

  @override
  Student rebuild(void updates(StudentBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  StudentBuilder toBuilder() => new StudentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Student &&
        id == other.id &&
        name == other.name &&
        grade == other.grade &&
        photo == other.photo;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, id.hashCode), name.hashCode), grade.hashCode),
        photo.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Student')
          ..add('id', id)
          ..add('name', name)
          ..add('grade', grade)
          ..add('photo', photo))
        .toString();
  }
}

class StudentBuilder implements Builder<Student, StudentBuilder> {
  _$Student _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _grade;
  String get grade => _$this._grade;
  set grade(String grade) => _$this._grade = grade;

  String _photo;
  String get photo => _$this._photo;
  set photo(String photo) => _$this._photo = photo;

  StudentBuilder();

  StudentBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _grade = _$v.grade;
      _photo = _$v.photo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Student other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Student;
  }

  @override
  void update(void updates(StudentBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Student build() {
    final _$result =
        _$v ?? new _$Student._(id: id, name: name, grade: grade, photo: photo);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
