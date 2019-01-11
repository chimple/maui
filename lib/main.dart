import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/app.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/reducers/red_state_reducer.dart';
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

//  final initialState = RootState(collectionMap: {}, cardMap: {});
//  final store = Store<RootState>(initialState);
//
//  store.add(CollectionMiddleware(
//      collectionRepo: CollectionRepo(),
//      cardProgressRepo: CardProgressRepo(),
//      likeRepo: LikeRepo(),
//      cardRepo: CardRepo(),
//      tileRepo: TileRepo(),
//      cardExtraRepo: CardExtraRepo(),
//      userRepo: UserRepo(),
//      commentRepo: CommentRepo()));

  runApp(
    StoreProvider(
      store: reduxStore,
      child: AppStateContainer(
        child: MauiApp(),
      ),
    ),
  );
}
