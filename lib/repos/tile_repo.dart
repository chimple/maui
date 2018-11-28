import 'dart:async';
import 'dart:io';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/dao/tile_dao.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class TileRepo {
  static final TileDao tileDao = TileDao();

  const TileRepo();

  Future<Tile> getTile(String id) async {
    final tile = await tileDao.getTile(id);
    if (tile.type == TileType.drawing || tile.type == TileType.dot) {
      tile.content = await _readFile(id: tile.id);
    }
    return tile;
  }

  Future<List<Tile>> getTilesByCardId(String cardId) async {
    final tiles = await tileDao.getTilesByCardId(cardId);
    await Future.forEach(
        tiles
            .where((t) => t.type == TileType.drawing || t.type == TileType.dot),
        (t) async => t.content = await _readFile(id: t.id));
    return tiles;
  }

  Future<List<Tile>> getTilesByCardIdAndType(
      String cardId, TileType type) async {
    final tiles = await tileDao.getTilesByCardIdAndType(cardId, type);
    await Future.forEach(
        tiles
            .where((t) => t.type == TileType.drawing || t.type == TileType.dot),
        (t) async => t.content = await _readFile(id: t.id));
    return tiles;
  }

  Future<List<Tile>> getTilesByUserIdAndType(
      String userId, TileType type) async {
    final tiles = await tileDao.getTilesByUserIdAndType(userId, type);
    await Future.forEach(
        tiles
            .where((t) => t.type == TileType.drawing || t.type == TileType.dot),
        (t) async => t.content = await _readFile(id: t.id));
    return tiles;
  }

  Future<List<Tile>> getTilesByCardIdAndUserIdAndType(
      String cardId, String userId, TileType type) async {
    final tiles =
        await tileDao.getTilesByCardIdAndUserIdAndType(cardId, userId, type);
    await Future.forEach(
        tiles
            .where((t) => t.type == TileType.drawing || t.type == TileType.dot),
        (t) async => t.content = await _readFile(id: t.id));
    return tiles;
  }

  Future<List<Tile>> getTilesOtherThanDots() async {
    final tiles = await tileDao.getTilesOtherThanDots();
    await Future.forEach(
        tiles
            .where((t) => t.type == TileType.drawing || t.type == TileType.dot),
        (t) async => t.content = await _readFile(id: t.id));
    return tiles;
  }

  Future<int> delete(int id) async {
    return await tileDao.delete(id);
  }

  Future<Tile> insert(Tile tile) async {
    return await tileDao.insert(tile);
  }

  Future<Tile> upsert(Tile tile) async {
    final existingTile = await tileDao.getTile(tile.id);
    final updatedTile =
        await _upsert(updatedTile: tile, existingTile: existingTile);
    return updatedTile;
  }

  Future<Tile> _upsert({Tile updatedTile, Tile existingTile}) async {
    if (existingTile == null) {
      if (updatedTile.type == TileType.drawing ||
          updatedTile.type == TileType.dot) {
        await _saveFile(id: updatedTile.id, contents: updatedTile.content);
        final content = updatedTile.content;
        updatedTile.content = '';
        final returnTile = await tileDao.insert(updatedTile);
        returnTile.content = content;
        return returnTile;
      }
      return await tileDao.insert(updatedTile);
    } else {
      existingTile.likes = updatedTile.likes ?? existingTile.likes;
      existingTile.comments = updatedTile.comments ?? existingTile.comments;
      existingTile.updatedAt = DateTime.now();
      if (updatedTile.content != null) {
        await _saveFile(id: updatedTile.id, contents: updatedTile.content);
        await tileDao.update(existingTile);
        existingTile.content = updatedTile.content;
        return existingTile;
      }
      await tileDao.update(existingTile);
      return existingTile;
    }
  }

  static Future<Null> _saveFile({String id, String contents}) async {
    final file = await _getFile(id: id);
    await file.writeAsString(contents);
    return;
  }

  static Future<File> _getFile({String id}) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$id.json');
  }

  static Future<String> _readFile({String id}) async {
    final file = await _getFile(id: id);
    return await file.readAsString();
  }

  Future<Tile> upsertByCardIdAndUserIdAndType(
      String cardId, String userId, TileType type,
      {String content, int likes, int comments}) async {
    final existingTile = await tileDao.getTileByCardIdAndUserId(cardId, userId);
    final tile = Tile(
        id: Uuid().v4(),
        cardId: cardId,
        userId: userId,
        type: type,
        updatedAt: DateTime.now(),
        content: content,
        likes: likes,
        comments: comments);
    final updatedTile =
        await _upsert(updatedTile: tile, existingTile: existingTile);
    return updatedTile;
  }

  Future<Null> incrementComments(String id, int comments) async {
    return tileDao.incrementComments(id, comments);
  }

  Future<Null> incrementLikes(String id, int likes) async {
    return tileDao.incrementLikes(id, likes);
  }
}
