import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_collections.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/collection_repo.dart';

class CollectionMiddleware extends Middleware<RootState> {
  final CollectionRepo _collectionRepo;

  CollectionMiddleware(this._collectionRepo);

  @override
  RootState beforeAction(ActionType action, RootState state) {
    if (action is FetchCollections) {
      action.collectionRepo = _collectionRepo;
    }
    return state;
  }

  @override
  RootState afterAction(ActionType action, RootState state) {
    return state;
  }
}
