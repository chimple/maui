import 'package:maui/db/entity/collection.dart';
import 'package:maui/db/entity/quack_card.dart';

class RootState {
  final Map<String, List<String>> collectionMap;
  final Map<String, QuackCard> cardMap;

  RootState({this.collectionMap, this.cardMap});
}
