import 'dart:async';

import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/dao/card_progress_dao.dart';

class CardProgressRepo {
  static final CardProgressDao cardProgressDao = CardProgressDao();

  const CardProgressRepo();

  Future<CardProgress> getCardProgressByCardIdAndUserId(
      String cardId, String userId) async {
    return await cardProgressDao.getCardProgressByCardIdAndUserId(
        cardId, userId);
  }

  Future<CardProgress> upsert(CardProgress cardProgress) async {
    CardProgress existingCardProgress =
        await cardProgressDao.getCardProgressByCardIdAndUserId(
            cardProgress.cardId, cardProgress.userId);
    if (existingCardProgress == null) {
      await cardProgressDao.insert(cardProgress);
    } else {
      if (existingCardProgress.maxScore <= cardProgress.maxScore) {
        await cardProgressDao.update(cardProgress);
      } else {
        return existingCardProgress;
      }
    }
    return cardProgress;
  }
}
