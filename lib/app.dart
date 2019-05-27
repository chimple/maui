import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maui/screens/home_screen.dart';
import 'package:maui/screens/map_screen.dart';
import 'package:maui/screens/profile_screen.dart';
import 'package:maui/screens/store_screen.dart';
import 'package:maui/screens/story_screen.dart';
import 'package:maui/widgets/game_list.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/main_collection.dart';
import 'package:maui/quack/story_page.dart';
import 'package:maui/screens/friend_list_view.dart';
import 'package:maui/screens/login_screen.dart';
import 'package:maui/screens/progress_screen.dart';
import 'package:maui/screens/quiz_performance_screen.dart';
import 'package:maui/screens/quiz_waiting_screen.dart';
import 'package:maui/screens/switch_screen.dart';
import 'package:maui/screens/welcome_screen.dart';

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
        '/camera': (BuildContext context) => CameraScreen(false),
        '/stories': (BuildContext context) => StoryPage(),
        '/topics': (BuildContext context) => MainCollection(),
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

    if (path[1] == 'card' && path.length == 4) {
//      Provider.dispatch<RootState>(context, FetchCardDetail(card.id));

      return new MaterialPageRoute<Null>(
        settings: settings,
        builder: (BuildContext context) => new CardDetail(),
      );
    }

    return null;
  }
}
