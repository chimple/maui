// GENERATED CODE - DO NOT MODIFY BY HAND

part of serializers;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(ChatChoice.serializer)
      ..add(ChatQuestion.serializer)
      ..add(ChatScript.serializer)
      ..add(ClassInterest.serializer)
      ..add(ClassJoin.serializer)
      ..add(ClassSession.serializer)
      ..add(ClassStudents.serializer)
      ..add(CrosswordData.serializer)
      ..add(GameConfig.serializer)
      ..add(GameStatus.serializer)
      ..add(ImageData.serializer)
      ..add(ImageItemDetail.serializer)
      ..add(MathOpData.serializer)
      ..add(MultiData.serializer)
      ..add(NumMultiData.serializer)
      ..add(Page.serializer)
      ..add(Performance.serializer)
      ..add(QuizJoin.serializer)
      ..add(QuizSession.serializer)
      ..add(QuizUpdate.serializer)
      ..add(Score.serializer)
      ..add(StatusEnum.serializer)
      ..add(Stories.serializer)
      ..add(StoryConfig.serializer)
      ..add(Student.serializer)
      ..add(UserProfile.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GameData)]),
          () => new ListBuilder<GameData>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ImageData)]),
          () => new ListBuilder<ImageData>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => new ListBuilder<BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ImageItemDetail)]),
          () => new ListBuilder<ImageItemDetail>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Page)]),
          () => new ListBuilder<Page>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Performance)]),
          () => new ListBuilder<Performance>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(StoryConfig)]),
          () => new ListBuilder<StoryConfig>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Student)]),
          () => new ListBuilder<Student>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => new ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => new ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => new ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(ChatQuestion)]),
          () => new MapBuilder<String, ChatQuestion>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(ChatChoice)]),
          () => new MapBuilder<String, ChatChoice>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(GameStatus)]),
          () => new MapBuilder<String, GameStatus>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => new MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => new MapBuilder<String, String>()))
    .build();

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
