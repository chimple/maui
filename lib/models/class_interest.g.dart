// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_interest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ClassInterest> _$classInterestSerializer =
    new _$ClassInterestSerializer();

class _$ClassInterestSerializer implements StructuredSerializer<ClassInterest> {
  @override
  final Iterable<Type> types = const [ClassInterest, _$ClassInterest];
  @override
  final String wireName = 'ClassInterest';

  @override
  Iterable serialize(Serializers serializers, ClassInterest object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'sessionId',
      serializers.serialize(object.sessionId,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ClassInterest deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClassInterestBuilder();

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
      }
    }

    return result.build();
  }
}

class _$ClassInterest extends ClassInterest {
  @override
  final String sessionId;

  factory _$ClassInterest([void updates(ClassInterestBuilder b)]) =>
      (new ClassInterestBuilder()..update(updates)).build();

  _$ClassInterest._({this.sessionId}) : super._() {
    if (sessionId == null) {
      throw new BuiltValueNullFieldError('ClassInterest', 'sessionId');
    }
  }

  @override
  ClassInterest rebuild(void updates(ClassInterestBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassInterestBuilder toBuilder() => new ClassInterestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassInterest && sessionId == other.sessionId;
  }

  @override
  int get hashCode {
    return $jf($jc(0, sessionId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassInterest')
          ..add('sessionId', sessionId))
        .toString();
  }
}

class ClassInterestBuilder
    implements Builder<ClassInterest, ClassInterestBuilder> {
  _$ClassInterest _$v;

  String _sessionId;
  String get sessionId => _$this._sessionId;
  set sessionId(String sessionId) => _$this._sessionId = sessionId;

  ClassInterestBuilder();

  ClassInterestBuilder get _$this {
    if (_$v != null) {
      _sessionId = _$v.sessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassInterest other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClassInterest;
  }

  @override
  void update(void updates(ClassInterestBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassInterest build() {
    final _$result = _$v ?? new _$ClassInterest._(sessionId: sessionId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
