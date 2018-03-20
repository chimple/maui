import 'package:flutter/material.dart';
import 'package:maui/games/head_to_head_game.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/screens/login_screen.dart';
import 'package:maui/screens/tab_home.dart';

class MauiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Maui',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new LoginScreen(),
        '/tab': (BuildContext context) => new TabHome(title: 'Maui'),
      },
      onGenerateRoute: _getRoute,
    );
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    print(path);
    if (path[0] != '')
      return null;
    if (path[1] == 'games' && path.length == 4) {
      switch(path[3]) {
        case 'single_iterations':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new SingleGame(path[2], maxIterations: 2,),
          );
        case 'single_timed':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new SingleGame(path[2], playTime: 30000,),
          );
        case 'h2h_iterations':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new HeadToHeadGame(path[2], maxIterations: 2),
          );
        case 'h2h_timed':
          return new MaterialPageRoute<Null>(
            settings: settings,
            builder: (BuildContext context) => new HeadToHeadGame(path[2], playTime: 30000),
          );
      }
    }
    return null;
  }
}
