import 'package:flutter/cupertino.dart';
import 'package:maui/screens/profile_view.dart';

class NewPageRoute extends CupertinoPageRoute {
  NewPageRoute()
      : super(builder: (BuildContext context) => new ProfileView());

// Animation Integration
@override
 Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(
      opacity: animation,
      child: new ProfileView(),
    );
  }
}