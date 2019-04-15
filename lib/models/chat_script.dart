import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_script.g.dart';

abstract class ChatQuestion
    implements Built<ChatQuestion, ChatQuestionBuilder> {
  String get question;

  @nullable
  String get emotion;

  BuiltList<String> get choices;

  ChatQuestion._();
  factory ChatQuestion([updates(ChatQuestionBuilder b)]) = _$ChatQuestion;
  static Serializer<ChatQuestion> get serializer => _$chatQuestionSerializer;
}

abstract class ChatChoice implements Built<ChatChoice, ChatChoiceBuilder> {
  String get choice;

  @nullable
  String get reply;

  @nullable
  BuiltList<String> get questions;

  ChatChoice._();
  factory ChatChoice([updates(ChatChoiceBuilder b)]) = _$ChatChoice;
  static Serializer<ChatChoice> get serializer => _$chatChoiceSerializer;
}

abstract class ChatScript implements Built<ChatScript, ChatScriptBuilder> {
  BuiltMap<String, ChatQuestion> get questions;
  BuiltMap<String, ChatChoice> get choices;

  ChatScript._();
  factory ChatScript([updates(ChatScriptBuilder b)]) = _$ChatScript;
  static Serializer<ChatScript> get serializer => _$chatScriptSerializer;
}
