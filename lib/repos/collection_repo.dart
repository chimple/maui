import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/card.dart';
import 'package:maui/db/entity/collection.dart';
import 'package:maui/db/dao/collection_dao.dart';

class CollectionRepo {
  static final CollectionDao collectionDao = new CollectionDao();

  const CollectionRepo();

  Future<Collection> getCollection(String id) async {
    return collectionDao.getCollection(id);
  }

  Future<List<Card>> getCardsInCollection(String id) async {
    return collectionDao.getCardsInCollection(id);
  }
}
