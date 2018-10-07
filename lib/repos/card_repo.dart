import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/card.dart';
import 'package:maui/db/dao/card_dao.dart';

class CardRepo {
  static final CardDao cardDao = new CardDao();

  const CardRepo();

  Future<Card> getCard(String id) async {
    return cardDao.getCard(id);
  }
}
