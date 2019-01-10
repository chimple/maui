import 'package:maui/actions/user_actions.dart';
import 'package:maui/db/entity/user.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<User>([
  TypedReducer<User, UserSetAction>(_setUser),
]);

User _setUser(User user, UserSetAction action) {
  return action.user;
}
