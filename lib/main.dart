import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/app.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('deviceId') == null) {
    prefs.setString('deviceId', Uuid().v4());
  }
  final initialState = RootState(collectionMap: {}, cardMap: {});
  final store = Store<RootState>(initialState);

  store.add(CollectionMiddleware(
      collectionRepo: CollectionRepo(),
      cardProgressRepo: CardProgressRepo(),
      likeRepo: LikeRepo(),
      cardRepo: CardRepo(),
      tileRepo: TileRepo(),
      cardExtraRepo: CardExtraRepo(),
      userRepo: UserRepo(),
      commentRepo: CommentRepo()));

  runApp(Provider(
    store: store,
    child: AppStateContainer(
      child: MauiApp(),
    ),
  ));
}
