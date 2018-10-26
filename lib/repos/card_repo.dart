import 'dart:async';
import 'dart:core';

import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/dao/card_dao.dart';
import 'package:maui/db/dao/card_extra_dao.dart';
import 'package:maui/db/entity/quiz.dart';

class CardRepo {
  static final CardDao cardDao = CardDao();
  static final CardExtraDao cardExtraDao = CardExtraDao();

  const CardRepo();

  Future<QuackCard> getCard(String id) async {
    return cardDao.getCard(id);
  }

  Future<Quiz> getQuiz(String id) async {
    final card = await cardDao.getCard(id);
    final answers = await cardExtraDao.getCardExtrasByCardIdAndType(
        id, CardExtraType.answer);
    final choices = await cardExtraDao.getCardExtrasByCardIdAndType(
        id, CardExtraType.choice);
    return Quiz(
      id: card.id,
      type: quizTypeMap[card.option],
      question: card.title,
      questionAudio: card.titleAudio,
      header: card.header,
      answers: answers.map((a) => a.content).toList(growable: false),
      answerAudios: answers.map((a) => a.contentAudio).toList(growable: false),
      choices: choices.map((a) => a.content).toList(growable: false),
      choiceAudios: answers.map((a) => a.contentAudio).toList(growable: false),
    );
  }

  Future<Null> incrementComments(String id, int comments) async {
    return cardDao.incrementComments(id, comments);
  }

  Future<Null> incrementLikes(String id, int likes) async {
    return cardDao.incrementLikes(id, likes);
  }
}
