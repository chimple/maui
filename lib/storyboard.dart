import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/story_screen.dart';
import 'package:maui/storyboards/collected_item_story.dart';
import 'package:maui/storyboards/game_score_story.dart';
import 'package:maui/storyboards/games/bingo_game_story.dart';
import 'package:maui/storyboards/games/compare_number_game_story.dart';
import 'package:maui/storyboards/games/counting_game_story.dart';
import 'package:maui/storyboards/games/crossword_game_story.dart';
import 'package:maui/storyboards/games/dice_game_story.dart';
import 'package:maui/storyboards/games/fill_in_the_blanks_story.dart';
import 'package:maui/storyboards/games/find_word_game_story.dart';
import 'package:maui/storyboards/games/finger_game_story.dart';
import 'package:maui/storyboards/games/game_list_story.dart';
import 'package:maui/storyboards/games/jumbled_words_game_story.dart';
import 'package:maui/storyboards/games/box_matching_game_story.dart';
import 'package:maui/storyboards/games/match_the_shape_game_story.dart';
import 'package:maui/storyboards/games/match_with_image_game_story.dart';
import 'package:maui/storyboards/games/math_op_game_story.dart';
import 'package:maui/storyboards/games/memory_game_story.dart';
import 'package:maui/storyboards/games/number_balance_game_story.dart';
import 'package:maui/storyboards/games/order_by_size_game_story.dart';
import 'package:maui/storyboards/games/order_it_game_story.dart';
import 'package:maui/storyboards/games/recognize_number_game_story.dart';
import 'package:maui/storyboards/games/reflex_game_story.dart';
import 'package:maui/storyboards/games/rhyme_words_game_story.dart';
import 'package:maui/storyboards/games/ruler_game_story.dart';
import 'package:maui/storyboards/games/sequence_alphabet_game_story.dart';
import 'package:maui/storyboards/games/sequence_the_number_game_story.dart';
import 'package:maui/storyboards/games/basic_counting_game_story.dart';
import 'package:maui/storyboards/games/spin_wheel_game_story.dart';
import 'package:maui/storyboards/games/tap_wrong_game_story.dart';
import 'package:maui/storyboards/games/tracing_alphabets_story.dart';
import 'package:maui/storyboards/games/true_false_game_story.dart';
import 'package:maui/storyboards/monster_game_story.dart';
import 'package:maui/storyboards/map_reward_screen_story.dart';
import 'package:maui/storyboards/screens/loggin_as.dart';
import 'package:maui/storyboards/user_progress_screen_story.dart';
import 'package:maui/storyboards/widgets/audio_widget_story.dart';
import 'package:maui/storyboards/widgets/bento_box_story.dart';
import 'package:maui/storyboards/widgets/chat_bot_screen_story.dart';
import 'package:maui/storyboards/widgets/chat_bot_story.dart';
import 'package:maui/storyboards/widgets/cute_button_story.dart';
import 'package:maui/storyboards/widgets/dot_number_story.dart';
import 'package:maui/storyboards/games/game_level_story.dart';
import 'package:maui/storyboards/games/score_screen_story.dart';
import 'package:maui/storyboards/theme_map_story.dart';
import 'package:maui/storyboards/widgets/game_story.dart';
import 'package:maui/storyboards/widgets/score_story.dart';
import 'package:maui/storyboards/widgets/select_student_screen_story.dart';
import 'package:maui/storyboards/widgets/select_teacher_screen_story.dart';
import 'package:maui/storyboards/widgets/slide_up_route_story.dart';
import 'package:maui/storyboards/widgets/story_board.dart';
import 'package:maui/storyboards/widgets/store_screen_story.dart';
import 'package:storyboard/storyboard.dart';

void main() {
  runApp(StoryboardApp([
    GameScoreStory(),
    CompareNumberGameStroy(),
    RulerNumbersGameStory(),
    AudioWidgetStory(),
    BasicCountingGameStory(),
    BentoBoxStory(),
    BingoGameStory(),
    NumberBalanceGameStory(),
    BoxMatchingGameStory(),
    ChatBotStory(),
    ChatBotScreenStory(),
    CollectedItemStory(),
    CountingGameStory(),
    CrosswordGameStory(),
    CuteButtonStory(),
    DiceGameStory(),
    DotNumberStory(),
    FillInTheBlanksGameStory(),
    FindWordGameStory(),
    FingerGameStory(),
    GameStory(),
    GameLevelStory(),
    GameListStory(),
    JumbledWordsGameStory(),
    MatchTheShapeGameStory(),
    MatchWithImageGameStory(),
    MathOpGameStory(),
    MemoryGameStory(),
    MonsterGameStory(),
    OrderBySizeGameStory(),
    OrderItGameStory(),
    RecognizeNumberGameStory(),
    ReflexGameStory(),
    RhymeWordsGameStory(),
    SelectTeacherScreenStory(),
    SelectStudentScreenStory(),
    SequenceAlphabetGameStory(),
    SequenceTheNumberGameStory(),
    SlideUpRouteStory(),
    SpinWheelGameStory(),
    StoreScreenStory(),
    ScoreStory(),
    StoryBoard(),
    TapWrongGameStory(),
    ThemeMapStory(),
    TracingAlphabetStory(),
    TrueFalseGameStory(),
    MapRewardsScreenStory(),
    UserProgressScreenStory(),
    LoginAsStory()
  ]));
}
