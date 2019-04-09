import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/app.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/middlewares/collections_middleware.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_extra_repo.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:redux/src/store.dart' as redux;
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('deviceId') == null) {
    prefs.setString('deviceId', Uuid().v4());
  }

  final reduxStore = redux.Store<RedState>(appReducer,
      initialState: RedState.loading(),
      middleware: [
        thunkMiddleware,
        LoggingMiddleware.printer(),
      ]);

  runApp(Provider(
    store: store,
    child: AppStateContainer(
      child: StateContainer(child: MauiApp()),
    ),
  );
}
