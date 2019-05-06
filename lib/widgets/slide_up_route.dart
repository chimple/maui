import 'package:flutter/material.dart';

class SlideUpRoute extends PageRouteBuilder {
  final WidgetBuilder widgetBuilder;

  SlideUpRoute({this.widgetBuilder})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widgetBuilder(context);
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 2.0),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(0.0, -2.0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 1000),
          maintainState: false,
        );
}
