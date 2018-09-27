import 'package:maui/db/entity/home.dart';
import 'package:maui/db/dao/home_page_dao.dart';
import 'dart:async';

class HomeRepo {
  const HomeRepo();
  static final HomeDao homeDao = new HomeDao();

  Future<List<Home>> getHomeTiles() async {
    var homeTiles = await homeDao.getHomeTiles();
    return homeTiles;
  }

  Future<String> insertAHomeTile(
      String tileId, String userId, String type, String typeId) async {
    await homeDao.insertAHomeTile(
        new Home(tileId: tileId, type: type, typeId: typeId, userId: userId));
    return "hopme tile inserted";
  }

  Future<String> deleteAHomeTile(
      String tileId, String userId, String type, String typeId) async {
    await homeDao.deleteAHomeTile(
        new Home(tileId: tileId, type: type, typeId: typeId, userId: userId));
    return "hopme tile inserted";
  }
}
