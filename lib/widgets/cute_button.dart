import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:maui/models/display_item.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/display_item_widget.dart';

typedef Reaction OnPressed();
typedef void OnDragEnd(DraggableDetails d);
typedef void OnDragStarted();

enum Reaction { enter, success, failure }

final Map<Reaction, String> _reactionMap = {
  Reaction.enter: 'enter',
  Reaction.success: 'happy',
  Reaction.failure: 'sad',
};
enum CuteButtonType { cuteButton, text }

class CuteButton extends StatelessWidget {
  final Widget child;
  final DisplayItem displayItem;
  final OnPressed onPressed;
  final Reaction reaction;
  final CuteButtonType cuteButtonType;
  final OnDragStarted onDragStarted;
  final DragTargetWillAccept<String> onWillAccept;
  final DragTargetAccept<String> onAccept;
  final DragTargetLeave<String> onLeave;

  const CuteButton({
    Key key,
    this.onPressed,
    this.reaction,
    this.child,
    this.onDragStarted,
    this.cuteButtonType = CuteButtonType.cuteButton,
    this.displayItem,
    this.onWillAccept,
    this.onAccept,
    this.onLeave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CuteButtonWrapper extends StatefulWidget {
  final CuteButton child;
  final OnDragEnd onDragEnd;
  final Axis axis;
  final DragConfig dragConfig;
  final Size size;
  final bool gridFeedback;

  const CuteButtonWrapper(
      {Key key,
      this.child,
      this.onDragEnd,
      this.axis,
      this.dragConfig = DragConfig.fixed,
      this.size,
      this.gridFeedback = false})
      : super(key: key);

  @override
  CuteButtonWrapperState createState() {
    return new CuteButtonWrapperState();
  }
}

enum _ButtonStatus { up, down, upToDown, downToUp }

class CuteButtonWrapperState extends State<CuteButtonWrapper> {
  _ButtonStatus buttonStatus = _ButtonStatus.down;
  Reaction reaction;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    reaction = widget.child.reaction;
    if (buttonStatus == _ButtonStatus.down) {
      buttonStatus = _ButtonStatus.downToUp;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (buttonStatus == _ButtonStatus.downToUp) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted)
          setState(() {
            buttonStatus = _ButtonStatus.up;
          });
      });
    } else if (buttonStatus == _ButtonStatus.upToDown) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted)
          setState(() {
            buttonStatus = _ButtonStatus.down;
            reaction = null;
          });
      });
    } else if (buttonStatus == _ButtonStatus.up) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted)
          setState(() {
            buttonStatus = _ButtonStatus.upToDown;
          });
      });
    }
    return widget.dragConfig == DragConfig.fixed
        ? buildButton(context, false)
        : Draggable(
            axis: widget.axis,
            child: buildButton(context, false),
            childWhenDragging:
                widget.dragConfig == DragConfig.draggableMultiPack
                    ? null
                    : Container(),
            feedback: buildButton(context, widget.gridFeedback),
            onDragStarted: () {
              if (widget.child.onDragStarted != null) {
                widget.child.onDragStarted();
              }
            },
            data: (widget.key as ValueKey<String>).value,
            onDragEnd: (d) {
              widget.onDragEnd(d);
              setState(() {
                buttonStatus = _ButtonStatus.downToUp;
                reaction = d.wasAccepted ? Reaction.success : Reaction.failure;
              });
            });
  }

  Widget buildButton(BuildContext context, bool gridFeedback) {
    if (widget.child.cuteButtonType == CuteButtonType.cuteButton)
      return SizedBox(
        width:
            gridFeedback == true ? widget.size.width + 50 : widget.size.width,
        height:
            gridFeedback == true ? widget.size.height + 50 : widget.size.height,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: RaisedButton(
              onPressed: () {
                if (widget.child.onPressed != null &&
                    buttonStatus == _ButtonStatus.down)
                  setState(() {
                    buttonStatus = _ButtonStatus.downToUp;
                    reaction = widget.child.onPressed();
                  });
              },
              elevation: 8.0,
              color: Colors.white,
              disabledColor: Colors.grey,
//              textColor: themeColors[
//                  AppStateContainer.of(context).userProfile.currentTheme],
              textColor: Colors.black,
              disabledTextColor: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(16.0))),
              child: Stack(
                children: <Widget>[
                  buttonStatus != _ButtonStatus.up
                      ? widget.child.displayItem != null
                          ? widget.child.onAccept != null
                              ? DragTarget<String>(
                                  builder: (context, candidateData,
                                          rejectedData) =>
                                      DisplayItemWidget(
                                        displayItem: widget.child.displayItem,
                                        size: widget.size,
                                      ),
                                  onAccept: widget.child.onAccept,
                                  onWillAccept: widget.child.onWillAccept,
                                  onLeave: widget.child.onLeave,
                                )
                              : DisplayItemWidget(
                                  displayItem: widget.child.displayItem,
                                  size: widget.size,
                                )
                          : widget.child.child
                      : Container(),
                  AnimatedPositioned(
                    top: (buttonStatus == _ButtonStatus.up ||
                            buttonStatus == _ButtonStatus.downToUp)
                        ? 0.0
                        : widget.size.height,
                    left: 0.0,
                    right: 0.0,
                    bottom: (buttonStatus == _ButtonStatus.up ||
                            buttonStatus == _ButtonStatus.downToUp)
                        ? 0.0
                        : -widget.size.height,
                    duration: Duration(milliseconds: 250),
                    child: FlareActor(
                      "assets/character/button.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: buttonStatus == _ButtonStatus.up
                          ? _reactionMap[reaction]
                          : 'dummy',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    else if (widget.child.cuteButtonType == CuteButtonType.text)
      return Center(
        child: Container(
          child: widget.child.displayItem != null
              ? DisplayItemWidget(
                  displayItem: widget.child.displayItem,
                  size: widget.size,
                )
              : widget.child.child,
        ),
      );
    else
      return Container();
  }
}
