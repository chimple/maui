library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:maui/models/chat_script.dart';
import 'package:maui/models/class_interest.dart';
import 'package:maui/models/class_join.dart';
import 'package:maui/models/class_session.dart';
import 'package:maui/models/class_students.dart';
import 'package:maui/models/crossword_data.dart';
import 'package:maui/models/game_config.dart';
import 'package:maui/models/game_data.dart';
import 'package:maui/models/image_label_data.dart';
import 'package:maui/models/quiz_update.dart';
import 'package:maui/models/game_status.dart';
import 'package:maui/models/math_op_data.dart';
import 'package:maui/models/multi_data.dart';
import 'package:maui/models/quiz_session.dart';
import 'package:maui/models/quiz_join.dart';
import 'package:maui/models/num_multi_data.dart';
import 'package:maui/models/performance.dart';
import 'package:maui/models/score.dart';
import 'package:maui/models/sentence_data.dart';
import 'package:maui/models/story_config.dart';
import 'package:maui/models/student.dart';
import 'package:maui/models/user_profile.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  ChatChoice,
  ChatQuestion,
  ChatScript,
  ClassInterest,
  ClassJoin,
  ClassSession,
  ClassStudents,
  QuizJoin,
  QuizSession,
  QuizUpdate,
  CrosswordData,
  GameConfig,
  GameData,
  GameStatus,
  ImageLabelData,
  MathOpData,
  MultiData,
  NumMultiData,
  Page,
  Performance,
  Score,
  SentenceData,
  StoryConfig,
  Stories,
  Student,
  UserProfile,
  WordWithImage,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
