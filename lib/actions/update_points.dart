import 'dart:async';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:uuid/uuid.dart';

class UpdatePoints implements AsyncAction<RootState> {
  final int points;

  UserRepo userRepo;

  UpdatePoints({this.points});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(userRepo != null, 'userRepo not injected');

    final user = state.user;
    user.points = (user.points ?? 0) + points;
    userRepo.update(user);

    return (RootState state) => RootState(
        frontMap: state.frontMap,
        user: user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap,
        commentMap: state.commentMap,
        tiles: state.tiles,
        userMap: state.userMap,
        drawings: state.drawings,
        templates: state.templates);
  }
}
