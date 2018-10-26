import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/dao/card_extra_dao.dart';

class CardExtraRepo {
  static final CardExtraDao cardExtraDao = new CardExtraDao();

  const CardExtraRepo();

  Future<List<CardExtra>> getCardExtrasByCardIdAndType(
      String cardId, CardExtraType cardExtraType) async {
    return cardExtraDao.getCardExtrasByCardIdAndType(cardId, cardExtraType);
  }
}
