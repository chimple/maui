import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/actions/comment_actions.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/quack/quiz_card_detail.dart';
import 'package:maui/quack/quiz_open.dart';
import 'package:redux/redux.dart';

class QuizOpenContainer extends StatelessWidget {
  final Quiz quiz;
  final CanProceed canProceed;

  const QuizOpenContainer({Key key, this.quiz, this.canProceed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, vm) {
        return QuizOpen(
          quiz: quiz,
          canProceed: canProceed,
          onAdd: vm.onAdd,
        );
      },
    );
  }
}

class _ViewModel {
  final Function(Comment) onAdd;

  _ViewModel({this.onAdd});

  static _ViewModel fromStore(Store<RedState> store) {
    return _ViewModel(
      onAdd: (Comment comment) {
        store.dispatch(addComment(
            comment: comment, tileType: TileType.card, addTile: true));
      },
    );
  }
}
