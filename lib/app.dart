import 'package:flutter/material.dart';
import 'package:maui/screens/login_screen.dart';
import 'package:maui/screens/tab_home.dart';
import 'package:maui/games/SingleGame.dart';
import 'package:maui/games/HeadToHeadGame.dart';

import 'package:maui/games/reflex.dart';

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
      if(path[3] == 'single') {
        return new MaterialPageRoute<Null>(
          settings: settings,
          builder: (BuildContext context) => new SingleGame(path[2]),
        );
      } else if(path[3] == 'h2h') {
        return new MaterialPageRoute<Null>(
          settings: settings,
          builder: (BuildContext context) => new HeadToHeadGame(path[2]),
        );
      }
    }
    return null;
  }
}
