import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/db/entity/collection.dart';
import 'package:maui/db/dao/collection_dao.dart';
import 'package:maui/repos/card_repo.dart';

class CollectionRepo {
  static final CollectionDao collectionDao = new CollectionDao();

  const CollectionRepo();

  Future<Collection> getCollection(String id) async {
    return collectionDao.getCollection(id);
  }

  Future<List<QuackCard>> getCardsInCollection(String id) async {
    return collectionDao.getCardsInCollection(id);
  }

  Future<List<QuackCard>> getCardsInCollectionByType(
      String id, CardType cardType) async {
    return collectionDao.getCardsInCollectionByType(id, cardType);
  }

  Future<List<Quiz>> getQuizzesInCollection(String id) async {
    final quizCards =
        await collectionDao.getCardsInCollectionByType(id, CardType.question);
    return Future.wait(quizCards
        .map((c) async => CardRepo().getQuiz(c.id))
        .toList(growable: false));
  }
}
