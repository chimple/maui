import 'dart:async';

import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/collection_repo.dart';

class FetchCollections implements AsyncAction<RootState> {
  CollectionRepo _collectionRepo;

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(_collectionRepo != null, 'CollectionRepo not injected');

    final cardMap = Map<String, QuackCard>();
    final collectionMap = Map<String, List<String>>();

    final mainCards =
        (await _collectionRepo.getCardsInCollection('main')).map((c) {
      cardMap[c.id] = c;
      return c.id;
    }).toList(growable: false);
    collectionMap['main'] = mainCards;

    await Future.forEach(mainCards, (mc) async {
      final cardNames =
          (await _collectionRepo.getCardsInCollection(mc)).map((c) {
        cardMap[c.id] = c;
        return c.id;
      }).toList(growable: false);
      collectionMap[mc] = cardNames;
    });

    return (RootState state) => RootState(
        collectionMap: state.collectionMap..addAll(collectionMap),
        cardMap: state.cardMap..addAll(cardMap));
  }

  void set collectionRepo(CollectionRepo collectionRepo) {
    _collectionRepo = collectionRepo;
  }
}
