import 'package:maui/db/entity/likes.dart';
import 'package:maui/db/dao/likes_dao.dart';
import 'dart:async';

class LikesRepo {
  const LikesRepo();
  static final LikesDao likesDao = new LikesDao();

  Future<List<Likes>> getLikesByTileId(String tileId) async {
    var likes = await likesDao.getLikesByTileId(tileId);
    return likes;
  }
}
