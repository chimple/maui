import 'dart:async';
import 'dart:core';

import 'package:maui/db/dao/card_comment_dao.dart';
import 'package:maui/db/entity/card_comment.dart';

class CardCommentRepo {
  static final CardCommentDao cardCommentDao = new CardCommentDao();

  const CardCommentRepo();

  Future<List<CardComment>> getCardCommentsByCardId(String id) async {
    return cardCommentDao.getCardCommentsByCardId(id);
  }

  Future<Null> insert(CardComment cardComment) async {
    return cardCommentDao.insert(cardComment);
  }

  Future<Null> update(CardComment cardComment) async {
    return cardCommentDao.update(cardComment);
  }

  Future<Null> delete(CardComment cardComment) async {
    return cardCommentDao.delete(cardComment);
  }
}
