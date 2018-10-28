import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';

class CollectionProgressIndicator extends StatelessWidget {
  final String collectionId;
  final String userId;

  const CollectionProgressIndicator({Key key, this.collectionId, this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('CollectionProgressIndicator:build: $collectionId');
    return Connect<RootState, double>(
        convert: (state) => state.progressMap[collectionId] ?? 0.0,
        where: (prev, next) => next != prev,
        builder: (progress) {
          print('CollectionProgressIndicator:progress: $progress');
          return LinearProgressIndicator(value: progress);
        });
  }
}
