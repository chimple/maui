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

  Future<int> getNumberOfLikesByTileId(String tileId) async {
    var likes = await likesDao.getLikesByTileId(tileId);
    return likes?.length ?? 0;
  }

  Future<String> insertOrDeleteLike(String tileId, String likedUserId) async {
    Likes like =
        await likesDao.getLikesByTileIdAndLikedUserId(tileId, likedUserId);
    if (like == null) {
      await likesDao
          .insertALike(new Likes(tileId: tileId, likedUserId: likedUserId));
      return "Like inserted";
    } else {
      await likesDao
          .deleteALike(new Likes(tileId: tileId, likedUserId: likedUserId));
      return "Like deleted";
    }
  }
}
