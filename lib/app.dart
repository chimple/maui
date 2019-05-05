import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maui/jamaica/screens/home_screen.dart';
import 'package:maui/jamaica/screens/map_screen.dart';
import 'package:maui/jamaica/screens/profile_screen.dart';
import 'package:maui/jamaica/screens/store_screen.dart';
import 'package:maui/jamaica/screens/story_screen.dart';
import 'package:maui/jamaica/widgets/game_list.dart';
import 'package:maui/old/games/head_to_head_game.dart';
import 'package:maui/old/games/single_game.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/main_collection.dart';
import 'package:maui/quack/story_page.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/game_category_list_screen.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/screens/login_screen.dart';
import 'package:maui/screens/progress_screen.dart';
import 'package:maui/screens/quiz_performance_screen.dart';
import 'package:maui/screens/quiz_waiting_screen.dart';
import 'package:maui/screens/switch_screen.dart';
import 'package:maui/screens/welcome_screen.dart';
import 'package:maui/state/app_state_container.dart';

import 'components/camera.dart';
import 'loca.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

class MauiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        const LocaDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const FallbackMaterialLocalisationsDelegate()
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('sw', ''),
      ],
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[routeObserver],
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new SwitchScreen(),
        '/login': (BuildContext context) => new LoginScreen(),
        '/welcome': (BuildContext context) => new WelcomeScreen(),
        '/progressScreen': (BuildContext context) => new ProgressScreen(),
        '/quizPerformanceScreen': (BuildContext context) =>
            new QuizPerformanceScreen(),
        '/quizWaitingScreen': (BuildContext context) => new QuizWaitingScreen(),
        '/chatbot': (BuildContext context) => new ChatBotScreen(),
        '/camera': (BuildContext context) => CameraScreen(false),
        '/stories': (BuildContext context) => StoryPage(),
        '/topics': (BuildContext context) => MainCollection(),
        '/games': (BuildContext context) => GameListView(),
        '/friends': (BuildContext context) => FriendListView(),
        '/jam_chatbot': (BuildContext context) => HomeScreen(),
        '/jam_profile': (BuildContext context) => ProfileScreen(),
        '/jam_map': (BuildContext context) => MapScreen(),
        '/jam_games': (BuildContext context) => GameList(),
        '/jam_store': (BuildContext context) => StoreScreen(),
        '/jam_story': (BuildContext context) => StoryScreen(),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    if (path[0] != '') return null;

    if (path[1] == 'categories' && path.length == 3) {
      return new MaterialPageRoute<Null>(
        settings: settings,
        builder: (BuildContext context) =>
            new GameCategoryListScreen(game: path[2]),
      );
    } else if (path[1] == 'games' && path.length == 6) {
      int gameCategoryId = int.parse(path[4], onError: (source) => null);
      Random random = new Random();
      final textMode = random.nextBool();
      var gameConfig = new GameConfig(
          gameCategoryId: gameCategoryId,
          questionUnitMode:
              textMode ? UnitMode.text : UnitMode.values[random.nextInt(5) % 3],
          answerUnitMode:
              textMode ? UnitMode.values[random.nextInt(5) % 3] : UnitMode.text,
          level: random.nextInt(10) + 1);

      switch (path[5]) {
        case 'single_iterations':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) {
              gameConfig.gameDisplay = GameDisplay.single;
              gameConfig.amICurrentPlayer = true;
              gameConfig.myScore = 0;
              gameConfig.otherScore = 0;
              gameConfig.orientation = MediaQuery.of(context).orientation;
              return new SingleGame(
                path[2],
                gameMode: GameMode.iterations,
                gameConfig: gameConfig,
              );
            },
          );
        case 'single_timed':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) {
              gameConfig.gameDisplay = GameDisplay.single;
              gameConfig.orientation = MediaQuery.of(context).orientation;
              return new SingleGame(
                path[2],
                gameMode: GameMode.timed,
                gameConfig: gameConfig,
              );
            },
          );
        case 'tbt_local':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) {
              gameConfig.gameDisplay = GameDisplay.localTurnByTurn;
              gameConfig.amICurrentPlayer = true;
              gameConfig.otherUser =
                  AppStateContainer.of(context).state.loggedInUser;
              gameConfig.myScore = 0;
              gameConfig.otherScore = 0;
              gameConfig.orientation = MediaQuery.of(context).orientation;
              return new SingleGame(
                path[2],
                gameMode: GameMode.iterations,
                gameConfig: gameConfig,
              );
            },
          );
        case 'h2h_iterations':
          gameConfig.orientation = Orientation.landscape;
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new HeadToHeadGame(
                  path[2],
                  gameMode: GameMode.iterations,
                  gameConfig: gameConfig,
                ),
          );
        case 'h2h_timed':
          gameConfig.orientation = Orientation.landscape;
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new HeadToHeadGame(
                  path[2],
                  gameMode: GameMode.timed,
                  gameConfig: gameConfig,
                ),
          );
      }
    } else if (path[1] == 'card' && path.length == 4) {
//      Provider.dispatch<RootState>(context, FetchCardDetail(card.id));

      return new MaterialPageRoute<Null>(
        settings: settings,
        builder: (BuildContext context) => new CardDetail(),
      );
    }

    return null;
  }
}
