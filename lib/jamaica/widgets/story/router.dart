import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  final double dirX, dirY;
  SlideRightRoute({this.widget, this.dirX, this.dirY, context})
      : super(pageBuilder: (context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          print('value $dirX, $dirY');
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                .animate(animation),
            child: child,
          );
        });
}
