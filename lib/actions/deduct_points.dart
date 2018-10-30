import 'dart:async';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:uuid/uuid.dart';

class DeductPoints implements AsyncAction<RootState> {
  final int points;

  UserRepo userRepo;

  DeductPoints({this.points});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(userRepo != null, 'userRepo not injected');

    final user = state.user;
    print("before detecting the score is....${user.points}");
    user.points = (user.points ?? 0) - points;
    userRepo.update(user);
    print("afterdetecting the score is....${user.points}");
    return (RootState state) => RootState(
        user: user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        likeMap: state.likeMap,
        commentMap: state.commentMap,
        tiles: state.tiles,
        templates: state.templates,
        progressMap: state.progressMap);
  }
}
