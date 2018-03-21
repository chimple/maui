import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/db/entity/user.dart';

class AppStateContainerController extends StatefulWidget {
  final AppState state;
  final Widget child;

  AppStateContainerController({
    this.child,
    this.state
  });

  @override
  State<StatefulWidget> createState() => new _AppStateContainerControllerState();
}

class _AppStateContainerControllerState extends State<AppStateContainerController> {
  AppState state;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new AppStateContainer(
      state: state,
      setLoggedInUser: _setLoggedInUser,
      child: widget.child,
    );
  }

  _setLoggedInUser(User user) {
    setState(() {
      state = new AppState(loggedInUser: user);
    });
  }
}

class AppStateContainer extends InheritedWidget {
  final AppState state;
  final Function(User user) setLoggedInUser;

  const AppStateContainer({
    Key key,
    @required this.state,
    @required this.setLoggedInUser,
    @required Widget child,
  }) : assert(state != null),
        super(key: key, child: child);

  static AppStateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppStateContainer);
  }

  @override
  bool updateShouldNotify(AppStateContainer old) => state != old.state;

}