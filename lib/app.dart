import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/head_to_head_game.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/chat_bot_screen.dart';
import 'package:maui/screens/chat_screen.dart';
import 'package:maui/screens/game_category_list_screen.dart';
import 'package:maui/screens/login_screen.dart';
import 'package:maui/screens/tab_home.dart';
import 'package:maui/state/app_state_container.dart';

class MauiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LoginScreen(),
        '/tab': (BuildContext context) => new TabHome(),
        '/chatbot': (BuildContext context) => new ChatBotScreen()
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    print(path);
    if (path[0] != '') return null;

    if (path[1] == 'chat' && path.length == 4) {
      return new MaterialPageRoute<Null>(
          settings: settings,
          builder: (BuildContext context) => new ChatScreen(
                myId: AppStateContainer.of(context).state.loggedInUser.id,
                friendId: path[2],
                friendImageUrl: path[3].replaceAll(new RegExp(r'&#x2F;'), '/'),
              ));
    }

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
      var gameConfig = new GameConfig(
          gameCategoryId: gameCategoryId,
          questionUnitMode: UnitMode.values[random.nextInt(3)],
          answerUnitMode: UnitMode.values[random.nextInt(3)],
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
              return new SingleGame(
                path[2],
                gameMode: GameMode.iterations,
                gameConfig: gameConfig,
              );
            },
          );
        case 'single_timed':
          gameConfig.gameDisplay = GameDisplay.single;
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new SingleGame(
                  path[2],
                  gameMode: GameMode.timed,
                  gameConfig: gameConfig,
                ),
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
              return new SingleGame(
                path[2],
                gameMode: GameMode.iterations,
                gameConfig: gameConfig,
              );
            },
          );
        case 'h2h_iterations':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new HeadToHeadGame(
                  path[2],
                  gameMode: GameMode.iterations,
                  gameConfig: gameConfig,
                ),
          );
        case 'h2h_timed':
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
