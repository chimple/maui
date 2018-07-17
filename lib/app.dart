import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maui/games/head_to_head_game.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/screens/chat_screen.dart';
import 'package:maui/screens/game_category_list_screen.dart';
import 'package:maui/screens/login_screen.dart';
import 'package:maui/screens/tab_home.dart';
import 'package:maui/state/app_state_container.dart';
import 'components/camera.dart';
import 'loca.dart';

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
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LoginScreen(),
        '/tab': (BuildContext context) => new TabHome(),
        '/chatbot': (BuildContext context) => new ChatBotScreen(),
        '/camera': (BuildContext context) => CameraScreen()
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    print(path);
    if (path[0] != '') return null;

    if (path[1] == 'categories' && path.length == 3) {
      return new MaterialPageRoute<Null>(
        settings: settings,
        builder: (BuildContext context) =>
            new GameCategoryListScreen(game: path[2]),
      );
    }

    if (path[1] == 'games' && path.length == 6) {
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
    }
    return null;
  }
}
