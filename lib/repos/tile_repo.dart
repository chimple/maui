import 'dart:async';
import 'dart:convert';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/dao/tile_dao.dart';
import 'package:uuid/uuid.dart';

class TileRepo {
  static final TileDao tileDao = TileDao();

  const TileRepo();

  Future<Tile> getTile(String id) async {
    return tileDao.getTile(id);
  }

  Future<List<Tile>> getTilesByCardId(String cardId) async {
    return await tileDao.getTilesByCardId(cardId);
  }

  Future<List<Tile>> getTiles() async {
    return await tileDao.getTiles();
  }

  Future<int> delete(int id) async {
    return await tileDao.delete(id);
  }

  Future<Tile> upsert(Tile tile) async {
    final existingTile = await tileDao.getTile(tile.id);
    if (existingTile == null) {
      return await tileDao.insert(tile);
    } else {
      existingTile.content = tile.content ?? existingTile.content;
      existingTile.likes = tile.likes ?? existingTile.likes;
      existingTile.comments = tile.comments ?? existingTile.comments;
      existingTile.updatedAt = DateTime.now();
      await tileDao.update(existingTile);
      return existingTile;
    }
  }

  Future<Tile> upsertByCardIdAndUserIdAndType(
      String cardId, String userId, TileType type,
      {String content, int likes, int comments}) async {
    final existingTile = await tileDao.getTileByCardIdAndUserId(cardId, userId);
    if (existingTile == null) {
      return await tileDao.insert(Tile(
          id: Uuid().v4(),
          cardId: cardId,
          userId: userId,
          type: type,
          updatedAt: DateTime.now(),
          content: content,
          likes: likes,
          comments: comments));
    } else {
      existingTile.content = content ?? existingTile.content;
      existingTile.likes = likes ?? existingTile.likes;
      existingTile.comments = comments ?? existingTile.comments;
      existingTile.updatedAt = DateTime.now();
      await tileDao.update(existingTile);
      return existingTile;
    }
  }
}
