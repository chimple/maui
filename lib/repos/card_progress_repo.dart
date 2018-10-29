import 'dart:async';

import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/dao/card_progress_dao.dart';
import 'package:maui/db/dao/collection_dao.dart';

class CardProgressRepo {
  static final CardProgressDao cardProgressDao = CardProgressDao();
  static final CollectionDao collectionDao = CollectionDao();

  const CardProgressRepo();

  Future<CardProgress> getCardProgressByCardIdAndUserId(
      String cardId, String userId) async {
    return await cardProgressDao.getCardProgressByCardIdAndUserId(
        cardId, userId);
  }

  Future<List<CardProgress>> getCardProgressesByCollectionAndTypeAndUserId(
      String cardId, CardType cardType, String userId) async {
    return await cardProgressDao.getCardProgressesByCollectionAndTypeAndUserId(
        cardId, cardType, userId);
  }

  Future<CardProgress> upsert(CardProgress cardProgress) async {
    CardProgress existingCardProgress =
        await cardProgressDao.getCardProgressByCardIdAndUserId(
            cardProgress.cardId, cardProgress.userId);
    if (existingCardProgress == null) {
      await cardProgressDao.insert(cardProgress);
    } else {
      if (existingCardProgress.maxScore == null ||
          existingCardProgress.maxScore <= cardProgress.maxScore) {
        await cardProgressDao.update(cardProgress);
      } else {
        return existingCardProgress;
      }
    }
    return cardProgress;
  }

  Future<double> getProgressStatusByCollectionAndTypeAndUserId(
      String cardId, CardType cardType, String userId) async {
    final cardProgress =
        await cardProgressDao.getCardProgressByCardIdAndUserId(cardId, userId);
    if (cardProgress == null) return null;
    final cardProgressCount =
        await cardProgressDao.getCardProgressCountByCollectionAndTypeAndUserId(
            cardId, cardType, userId);
    final collectionCount =
        await collectionDao.getCardCountInCollectionByType(cardId, cardType);
    if (collectionCount != 0) {
      return cardProgressCount / collectionCount;
    }
    return 0.0;
  }

  Future<double> getProgressStatusByCollectionAndUserId(
      String cardId, String userId) async {
    final cardProgressCount = await cardProgressDao
        .getCardProgressCountByCollectionAndUserId(cardId, userId);
    final collectionCount =
        await collectionDao.getCardCountInCollection(cardId);
    if (collectionCount != 0) {
      return cardProgressCount / collectionCount;
    }
    return 0.0;
  }
}
