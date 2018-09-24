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
}
