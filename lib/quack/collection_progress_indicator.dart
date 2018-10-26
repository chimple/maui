import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/repos/card_progress_repo.dart';

class CollectionProgressIndicator extends StatefulWidget {
  final String collectionId;
  final String userId;

  const CollectionProgressIndicator({Key key, this.collectionId, this.userId})
      : super(key: key);

  @override
  CollectionProgressIndicatorState createState() {
    return new CollectionProgressIndicatorState();
  }
}

class CollectionProgressIndicatorState
    extends State<CollectionProgressIndicator> {
  double _progress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _progress = await CardProgressRepo()
        .getProgressStatusByCollectionAndTypeAndUserId(
            widget.collectionId, CardType.knowledge, widget.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(value: _progress);
  }
}
