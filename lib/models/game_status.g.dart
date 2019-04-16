// GENERATED CODE - DO NOT MODIFY BY HAND

part of game_status;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GameStatus> _$gameStatusSerializer = new _$GameStatusSerializer();

class _$GameStatusSerializer implements StructuredSerializer<GameStatus> {
  @override
  final Iterable<Type> types = const [GameStatus, _$GameStatus];
  @override
  final String wireName = 'GameStatus';

  @override
  Iterable serialize(Serializers serializers, GameStatus object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'currentLevel',
      serializers.serialize(object.currentLevel,
          specifiedType: const FullType(int)),
      'highestLevel',
      serializers.serialize(object.highestLevel,
          specifiedType: const FullType(int)),
      'maxScore',
      serializers.serialize(object.maxScore,
          specifiedType: const FullType(int)),
      'open',
      serializers.serialize(object.open, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  GameStatus deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GameStatusBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'currentLevel':
          result.currentLevel = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'highestLevel':
          result.highestLevel = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'maxScore':
          result.maxScore = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'open':
          result.open = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$GameStatus extends GameStatus {
  @override
  final int currentLevel;
  @override
  final int highestLevel;
  @override
  final int maxScore;
  @override
  final bool open;

  factory _$GameStatus([void Function(GameStatusBuilder) updates]) =>
      (new GameStatusBuilder()..update(updates)).build();

  _$GameStatus._(
      {this.currentLevel, this.highestLevel, this.maxScore, this.open})
      : super._() {
    if (currentLevel == null) {
      throw new BuiltValueNullFieldError('GameStatus', 'currentLevel');
    }
    if (highestLevel == null) {
      throw new BuiltValueNullFieldError('GameStatus', 'highestLevel');
    }
    if (maxScore == null) {
      throw new BuiltValueNullFieldError('GameStatus', 'maxScore');
    }
    if (open == null) {
      throw new BuiltValueNullFieldError('GameStatus', 'open');
    }
  }

  @override
  GameStatus rebuild(void Function(GameStatusBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameStatusBuilder toBuilder() => new GameStatusBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameStatus &&
        currentLevel == other.currentLevel &&
        highestLevel == other.highestLevel &&
        maxScore == other.maxScore &&
        open == other.open;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, currentLevel.hashCode), highestLevel.hashCode),
            maxScore.hashCode),
        open.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GameStatus')
          ..add('currentLevel', currentLevel)
          ..add('highestLevel', highestLevel)
          ..add('maxScore', maxScore)
          ..add('open', open))
        .toString();
  }
}

class GameStatusBuilder implements Builder<GameStatus, GameStatusBuilder> {
  _$GameStatus _$v;

  int _currentLevel;
  int get currentLevel => _$this._currentLevel;
  set currentLevel(int currentLevel) => _$this._currentLevel = currentLevel;

  int _highestLevel;
  int get highestLevel => _$this._highestLevel;
  set highestLevel(int highestLevel) => _$this._highestLevel = highestLevel;

  int _maxScore;
  int get maxScore => _$this._maxScore;
  set maxScore(int maxScore) => _$this._maxScore = maxScore;

  bool _open;
  bool get open => _$this._open;
  set open(bool open) => _$this._open = open;

  GameStatusBuilder();

  GameStatusBuilder get _$this {
    if (_$v != null) {
      _currentLevel = _$v.currentLevel;
      _highestLevel = _$v.highestLevel;
      _maxScore = _$v.maxScore;
      _open = _$v.open;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameStatus other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GameStatus;
  }

  @override
  void update(void Function(GameStatusBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GameStatus build() {
    final _$result = _$v ??
        new _$GameStatus._(
            currentLevel: currentLevel,
            highestLevel: highestLevel,
            maxScore: maxScore,
            open: open);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
