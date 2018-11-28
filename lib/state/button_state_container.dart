import 'package:flutter/material.dart';

class ButtonConfig {
  double fontSize;
  double width;
  double height;
  double radius;

  ButtonConfig({this.fontSize, this.width, this.height, this.radius});

  @override
  String toString() {
    return 'ButtonState{fontSize: $fontSize, width: $width, height: $height, radius: $radius';
  }
}

class ButtonStateContainer extends StatefulWidget {
  final Widget child;
  final ButtonConfig buttonConfig;

  ButtonStateContainer({
    @required this.child,
    this.buttonConfig,
  });

  static ButtonStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedButtonStateContainer)
            as _InheritedButtonStateContainer)
        ?.data;
  }

  @override
  ButtonStateContainerState createState() => new ButtonStateContainerState();
}

class ButtonStateContainerState extends State<ButtonStateContainer> {
  ButtonConfig buttonConfig;
  bool isButtonBeingUsed = false;

  void updateButtonConfig(
      {double fontSize, double width, double height, double radius}) {
    if (buttonConfig == null) {
      buttonConfig = new ButtonConfig(
          fontSize: fontSize, width: width, height: height, radius: radius);
      buttonConfig = buttonConfig;
    } else {
      buttonConfig.fontSize = fontSize ?? buttonConfig.fontSize;
      buttonConfig.width = width ?? buttonConfig.width;
      buttonConfig.height = height ?? buttonConfig.height;
      buttonConfig.radius = radius ?? buttonConfig.radius;
    }
  }

  bool startUsingButton() {
    if (isButtonBeingUsed) return false;
    setState(() {
      isButtonBeingUsed = true;
    });
    return isButtonBeingUsed;
  }

  void endUsingButton() {
    setState(() {
      isButtonBeingUsed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedButtonStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedButtonStateContainer extends InheritedWidget {
  final ButtonStateContainerState data;

  _InheritedButtonStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedButtonStateContainer old) => true;
}
