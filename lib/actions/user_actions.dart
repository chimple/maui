import 'package:maui/db/entity/user.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UserSetAction {
  final User user;

  UserSetAction({this.user});
}

ThunkAction<RedState> updatePoints({int points}) {
  return (Store<RedState> store) async {
    final user = store.state.user;
    user.points = (user.points ?? 0) + points;
    await UserRepo().update(user);
    //TODO dispatch action
  };
}
