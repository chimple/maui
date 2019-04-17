// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_script.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatQuestion> _$chatQuestionSerializer =
    new _$ChatQuestionSerializer();
Serializer<ChatChoice> _$chatChoiceSerializer = new _$ChatChoiceSerializer();
Serializer<ChatScript> _$chatScriptSerializer = new _$ChatScriptSerializer();

class _$ChatQuestionSerializer implements StructuredSerializer<ChatQuestion> {
  @override
  final Iterable<Type> types = const [ChatQuestion, _$ChatQuestion];
  @override
  final String wireName = 'ChatQuestion';

  @override
  Iterable serialize(Serializers serializers, ChatQuestion object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'question',
      serializers.serialize(object.question,
          specifiedType: const FullType(String)),
      'choices',
      serializers.serialize(object.choices,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.emotion != null) {
      result
        ..add('emotion')
        ..add(serializers.serialize(object.emotion,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  ChatQuestion deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatQuestionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'question':
          result.question = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'emotion':
          result.emotion = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'choices':
          result.choices.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ChatChoiceSerializer implements StructuredSerializer<ChatChoice> {
  @override
  final Iterable<Type> types = const [ChatChoice, _$ChatChoice];
  @override
  final String wireName = 'ChatChoice';

  @override
  Iterable serialize(Serializers serializers, ChatChoice object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'choice',
      serializers.serialize(object.choice,
          specifiedType: const FullType(String)),
    ];
    if (object.reply != null) {
      result
        ..add('reply')
        ..add(serializers.serialize(object.reply,
            specifiedType: const FullType(String)));
    }
    if (object.questions != null) {
      result
        ..add('questions')
        ..add(serializers.serialize(object.questions,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }

    return result;
  }

  @override
  ChatChoice deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatChoiceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'choice':
          result.choice = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reply':
          result.reply = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'questions':
          result.questions.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ChatScriptSerializer implements StructuredSerializer<ChatScript> {
  @override
  final Iterable<Type> types = const [ChatScript, _$ChatScript];
  @override
  final String wireName = 'ChatScript';

  @override
  Iterable serialize(Serializers serializers, ChatScript object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'questions',
      serializers.serialize(object.questions,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(ChatQuestion)])),
      'choices',
      serializers.serialize(object.choices,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(ChatChoice)])),
    ];

    return result;
  }

  @override
  ChatScript deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ChatScriptBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'questions':
          result.questions.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ChatQuestion)
              ])) as BuiltMap);
          break;
        case 'choices':
          result.choices.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(ChatChoice)
              ])) as BuiltMap);
          break;
      }
    }

    return result.build();
  }
}

class _$ChatQuestion extends ChatQuestion {
  @override
  final String question;
  @override
  final String emotion;
  @override
  final BuiltList<String> choices;

  factory _$ChatQuestion([void Function(ChatQuestionBuilder) updates]) =>
      (new ChatQuestionBuilder()..update(updates)).build();

  _$ChatQuestion._({this.question, this.emotion, this.choices}) : super._() {
    if (question == null) {
      throw new BuiltValueNullFieldError('ChatQuestion', 'question');
    }
    if (choices == null) {
      throw new BuiltValueNullFieldError('ChatQuestion', 'choices');
    }
  }

  @override
  ChatQuestion rebuild(void Function(ChatQuestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuestionBuilder toBuilder() => new ChatQuestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuestion &&
        question == other.question &&
        emotion == other.emotion &&
        choices == other.choices;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, question.hashCode), emotion.hashCode), choices.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChatQuestion')
          ..add('question', question)
          ..add('emotion', emotion)
          ..add('choices', choices))
        .toString();
  }
}

class ChatQuestionBuilder
    implements Builder<ChatQuestion, ChatQuestionBuilder> {
  _$ChatQuestion _$v;

  String _question;
  String get question => _$this._question;
  set question(String question) => _$this._question = question;

  String _emotion;
  String get emotion => _$this._emotion;
  set emotion(String emotion) => _$this._emotion = emotion;

  ListBuilder<String> _choices;
  ListBuilder<String> get choices =>
      _$this._choices ??= new ListBuilder<String>();
  set choices(ListBuilder<String> choices) => _$this._choices = choices;

  ChatQuestionBuilder();

  ChatQuestionBuilder get _$this {
    if (_$v != null) {
      _question = _$v.question;
      _emotion = _$v.emotion;
      _choices = _$v.choices?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuestion other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChatQuestion;
  }

  @override
  void update(void Function(ChatQuestionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChatQuestion build() {
    _$ChatQuestion _$result;
    try {
      _$result = _$v ??
          new _$ChatQuestion._(
              question: question, emotion: emotion, choices: choices.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'choices';
        choices.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ChatQuestion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChatChoice extends ChatChoice {
  @override
  final String choice;
  @override
  final String reply;
  @override
  final BuiltList<String> questions;

  factory _$ChatChoice([void Function(ChatChoiceBuilder) updates]) =>
      (new ChatChoiceBuilder()..update(updates)).build();

  _$ChatChoice._({this.choice, this.reply, this.questions}) : super._() {
    if (choice == null) {
      throw new BuiltValueNullFieldError('ChatChoice', 'choice');
    }
  }

  @override
  ChatChoice rebuild(void Function(ChatChoiceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatChoiceBuilder toBuilder() => new ChatChoiceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatChoice &&
        choice == other.choice &&
        reply == other.reply &&
        questions == other.questions;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, choice.hashCode), reply.hashCode), questions.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChatChoice')
          ..add('choice', choice)
          ..add('reply', reply)
          ..add('questions', questions))
        .toString();
  }
}

class ChatChoiceBuilder implements Builder<ChatChoice, ChatChoiceBuilder> {
  _$ChatChoice _$v;

  String _choice;
  String get choice => _$this._choice;
  set choice(String choice) => _$this._choice = choice;

  String _reply;
  String get reply => _$this._reply;
  set reply(String reply) => _$this._reply = reply;

  ListBuilder<String> _questions;
  ListBuilder<String> get questions =>
      _$this._questions ??= new ListBuilder<String>();
  set questions(ListBuilder<String> questions) => _$this._questions = questions;

  ChatChoiceBuilder();

  ChatChoiceBuilder get _$this {
    if (_$v != null) {
      _choice = _$v.choice;
      _reply = _$v.reply;
      _questions = _$v.questions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatChoice other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChatChoice;
  }

  @override
  void update(void Function(ChatChoiceBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChatChoice build() {
    _$ChatChoice _$result;
    try {
      _$result = _$v ??
          new _$ChatChoice._(
              choice: choice, reply: reply, questions: _questions?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'questions';
        _questions?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ChatChoice', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChatScript extends ChatScript {
  @override
  final BuiltMap<String, ChatQuestion> questions;
  @override
  final BuiltMap<String, ChatChoice> choices;

  factory _$ChatScript([void Function(ChatScriptBuilder) updates]) =>
      (new ChatScriptBuilder()..update(updates)).build();

  _$ChatScript._({this.questions, this.choices}) : super._() {
    if (questions == null) {
      throw new BuiltValueNullFieldError('ChatScript', 'questions');
    }
    if (choices == null) {
      throw new BuiltValueNullFieldError('ChatScript', 'choices');
    }
  }

  @override
  ChatScript rebuild(void Function(ChatScriptBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatScriptBuilder toBuilder() => new ChatScriptBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatScript &&
        questions == other.questions &&
        choices == other.choices;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, questions.hashCode), choices.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChatScript')
          ..add('questions', questions)
          ..add('choices', choices))
        .toString();
  }
}

class ChatScriptBuilder implements Builder<ChatScript, ChatScriptBuilder> {
  _$ChatScript _$v;

  MapBuilder<String, ChatQuestion> _questions;
  MapBuilder<String, ChatQuestion> get questions =>
      _$this._questions ??= new MapBuilder<String, ChatQuestion>();
  set questions(MapBuilder<String, ChatQuestion> questions) =>
      _$this._questions = questions;

  MapBuilder<String, ChatChoice> _choices;
  MapBuilder<String, ChatChoice> get choices =>
      _$this._choices ??= new MapBuilder<String, ChatChoice>();
  set choices(MapBuilder<String, ChatChoice> choices) =>
      _$this._choices = choices;

  ChatScriptBuilder();

  ChatScriptBuilder get _$this {
    if (_$v != null) {
      _questions = _$v.questions?.toBuilder();
      _choices = _$v.choices?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatScript other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChatScript;
  }

  @override
  void update(void Function(ChatScriptBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChatScript build() {
    _$ChatScript _$result;
    try {
      _$result = _$v ??
          new _$ChatScript._(
              questions: questions.build(), choices: choices.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'questions';
        questions.build();
        _$failedField = 'choices';
        choices.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ChatScript', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
