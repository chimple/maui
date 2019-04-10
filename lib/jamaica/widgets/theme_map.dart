import 'package:flutter/rendering.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/state_container.dart';

final List<String> _iconTitle = [
  'House',
  'Sports',
  'Gym',
  'Play Ground',
  'Cycle',
  'College',
  'School',
  'Teacher',
  'Book',
  'Cricket',
];

final List<String> _iconPath = [
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
  'assets/map/elephant.flr',
];
const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

class ThemeMap extends StatefulWidget {
  final List<String> flareBackgroundPath; // use later
  final List<String> flareIconPath; // use later
  final List<String> flareIconTitle; // use later
  ThemeMap({this.flareIconPath, this.flareIconTitle, this.flareBackgroundPath});
  @override
  _ThemeMapState createState() => new _ThemeMapState();
}

class _ThemeMapState extends State<ThemeMap>
    with SingleTickerProviderStateMixin {
  final List<int> _list = [0, 1];
  List<Offset> _iconPosition = List(5);
  Offset _offset = Offset(0.0, 0.0), _centerOffset;
  MediaQueryData _mediaQueryData;
  AnimationController _controller;
  String _text, _currentTheme;
  Size _iconSize;
  int _maxLength;
  bool _startAnimation = false;
  @override
  initState() {
    super.initState();
    _maxLength = _iconTitle.fold(
        0, (prev, element) => element.length > prev ? element.length : prev);
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _controller.addStatusListener((status) {
      print(status);
      if (_controller.isCompleted && _startAnimation) {
        new Future.delayed(Duration(milliseconds: 300), () {
          navigateToScreen(context, _text, _currentTheme);
        });
        new Future.delayed(Duration(milliseconds: 600), () {
          if (_controller != null) _controller.reset();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _startAnimation = false;
    });
  }

  void _animation(
      int index, BoxConstraints constraints, Orientation orientation) {
    _controller.forward();
    _offset = Offset(_centerOffset.dx - (_iconSize.width) / 2,
            _centerOffset.dy - (_iconSize.height) / 2) -
        _iconPosition[index];
    setState(() {
      _startAnimation = true;
      print(_offset);
    });
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final stateContainer = StateContainer.of(context);
    // print(
    //     'stateContainer.state.userProfile ${stateContainer.state..userProfile.name}');
    int _incr0 = 0;
    int _incr1 = 0;
    _mediaQueryData = MediaQuery.of(context);
    final ScrollPhysics physics = _kPagePhysics.applyTo(ScrollPhysics());
    return LayoutBuilder(
      key: Key('ThemeMap'),
      builder: (context, constraint) {
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          _iconSize = Size(constraint.maxWidth * .3, constraint.maxWidth * .25);
          _iconPosition[0] =
              (Offset(constraint.maxWidth * .10, constraint.maxHeight * .2));
          _iconPosition[1] =
              (Offset(constraint.maxWidth * .61, constraint.maxHeight * .2));
          _iconPosition[2] =
              (Offset(constraint.maxWidth * .35, constraint.maxHeight * .4));
          _iconPosition[3] =
              (Offset(constraint.maxWidth * .10, constraint.maxHeight * .6));
          _iconPosition[4] =
              (Offset(constraint.maxWidth * .61, constraint.maxHeight * .6));
        } else {
          _iconSize =
              Size(constraint.maxHeight * .28, constraint.maxHeight * .25);
          _iconPosition[0] =
              (Offset(constraint.maxWidth * .13, constraint.maxHeight * .2));
          _iconPosition[1] =
              (Offset(constraint.maxWidth * .43, constraint.maxHeight * .2));
          _iconPosition[2] =
              (Offset(constraint.maxWidth * .73, constraint.maxHeight * .2));
          _iconPosition[3] =
              (Offset(constraint.maxWidth * .25, constraint.maxHeight * .6));
          _iconPosition[4] =
              (Offset(constraint.maxWidth * .57, constraint.maxHeight * .6));
        }
        _centerOffset = Offset(constraint.maxWidth, constraint.maxHeight) / 2;
        return ListView(
          scrollDirection: Axis.horizontal,
          physics: (_controller.isAnimating || _startAnimation)
              ? NeverScrollableScrollPhysics()
              : physics,
          children: _list.map((s) {
            if ((_incr1 - 5) / 5 == 0) {
              _incr1 = 0;
            }
            return ConstrainedBox(
              constraints: constraint,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  FlareThemeMapBackground(
                    constraints: constraint,
                    index: s,
                    doAnimate: _startAnimation,
                  ),
                  ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 4.5)
                        .animate(CurvedAnimation(
                      parent: _controller,
                      curve: Interval(0.1, 1, curve: Curves.easeIn),
                    )),
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: _iconPosition.map((s) {
                          return Positioned(
                            left: s.dx,
                            top: s.dy,
                            child: Container(
                              child: _AnimatedWidget(
                                isAnimating: _controller.isAnimating,
                                animation: Tween<Offset>(
                                        begin: (_controller.isAnimating &&
                                                _iconPosition != null)
                                            ? _iconPosition[_incr1] -
                                                Offset(0.0, 0.0)
                                            : Offset.zero,
                                        end: (_controller.isAnimating &&
                                                _iconPosition != null)
                                            ? _iconPosition[_incr1++] + _offset
                                            : Offset.zero)
                                    .animate(CurvedAnimation(
                                        curve: Interval(0, 1,
                                            curve: Curves.fastOutSlowIn),
                                        parent: _controller)),
                                child: FlareIcon(
                                    iconPath: _iconPath[_incr0],
                                    iconSize: _iconSize,
                                    index: _incr0,
                                    constrainedBox: constraint,
                                    text: _iconTitle[_incr0++],
                                    maxLen: _maxLength,
                                    scaleAnimate: (
                                      int index,
                                      String t,
                                    ) {
                                      print(index % 5);
                                      _text = _iconTitle[index];
                                      _currentTheme = t;
                                      if (!_controller.isAnimating)
                                        _animation(index % 5, constraint,
                                            _mediaQueryData.orientation);
                                    }),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(growable: false),
        );
      },
    );
  }
}

class _AnimatedWidget extends AnimatedWidget {
  final Animation<Offset> animation;
  final Widget child;
  final bool isAnimating;
  _AnimatedWidget({Key key, this.animation, this.child, this.isAnimating})
      : super(key: key, listenable: animation);

  Animation<Offset> get listenable => super.listenable;
  double get translateX {
    return listenable.value.dx;
  }

  double get translateY {
    return listenable.value.dy;
  }

  @override
  Widget build(BuildContext context) {
    return _SingleChildRenderObject(
        isAnimating: isAnimating,
        child: child,
        offset: Offset(translateX, translateY));
  }
}

class _SingleChildRenderObject extends SingleChildRenderObjectWidget {
  final Widget child;
  final Offset offset;
  final bool isAnimating;
  _SingleChildRenderObject({this.child, this.offset, this.isAnimating})
      : super(child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    // print('redner box');
    return _RenderObject(offset: offset, isAnimating: isAnimating);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderObject renderObject) {
    super.updateRenderObject(
        context,
        renderObject
          ..startAnimation = isAnimating
          ..updateOffset = offset);
  }
}

class _RenderObject extends RenderProxyBox {
  final Offset offset;
  final bool isAnimating;
  _RenderObject({RenderBox child, this.offset, this.isAnimating = false})
      : assert(offset != null),
        _offset = offset,
        _doAnimation = isAnimating,
        super(child);
  Offset _offset;
  bool _doAnimation;
  set updateOffset(Offset of) {
    _offset = of;
    markNeedsPaint();
  }

  set startAnimation(bool b) {
    _doAnimation = b;
    markNeedsPaint();
  }

  @override
  void paint(context, offset) {
    if (child != null) {
      context.paintChild(child, !_doAnimation ? offset : _offset);
    }
  }
}

class FlareThemeMapBackground extends StatelessWidget {
  final BoxConstraints constraints;
  final bool doAnimate;
  final Offset offset;
  final int index;
  FlareThemeMapBackground(
      {this.constraints, this.index, this.doAnimate = false, this.offset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: Key('BackGroundImage${index}'),
      height: constraints.maxHeight,
      width: constraints.maxWidth,
      child: Center(
        child: FlareActor(
          'assets/map/map_background${index + 2}.flr',
          fit: MediaQuery.of(context).orientation == Orientation.portrait
              ? BoxFit.fitHeight
              : BoxFit.fitWidth,
          animation: 'bird',
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class FlareIcon extends StatelessWidget {
  final Size iconSize;
  final String iconPath;
  final String text;
  final int maxLen;
  final int index;
  final Function scaleAnimate;
  final BoxConstraints constrainedBox;
  final Function fractionalOffset;
  FlareIcon(
      {key,
      this.iconSize,
      this.iconPath,
      this.index,
      this.constrainedBox,
      this.text = 'Empty',
      this.scaleAnimate,
      this.fractionalOffset,
      this.maxLen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Key('Icon${index}'),
      child: InkWell(
        splashColor: Colors.white10,
        onTap: () {
          print(index);
          scaleAnimate(index, iconPath);
        },
        child: SizedBox(
          // key: _globalKey,
          height: iconSize.height,
          width: iconSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: iconSize.height * .35,
                width: iconSize.width * .7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: (iconSize.height * .35 * maxLen) / 32),
                  ),
                ),
              ),
              SizedBox(
                height: iconSize.height * .65,
                child: Container(
                  // color: Colors.red,
                  child: FlareActor(
                    iconPath ?? 'assets/map/elephant.flr',
                    fit: BoxFit.fill,
                    animation: 'door',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void navigateToScreen(BuildContext context, String text, String t) {
  StateContainer.of(context).setCurrentTheme(t);
  // print(StateContainer.of(context).state.userProfile.currentTheme);
  print(t);
  Widget child = Container(
    child: Center(
        child: Text(
      text,
      style: TextStyle(fontSize: 20),
    )),
  );
  switch (text) {
    case 'House':
      _router(context, text, child);
      break;
    case 'Sports':
      _router(context, text, child);
      break;
    case 'Gym':
      _router(context, text, child);
      break;
    case 'Play Ground':
      _router(context, text, child);
      break;
    case 'Cycle':
      _router(context, text, child);
      break;
    case 'College':
      _router(context, text, child);
      break;
    case 'Teacher':
      _router(context, text, child);
      break;
    case 'School':
      _router(context, text, child);
      break;
    case 'Cricket':
      _router(context, text, child);
      break;
    case 'Book':
      _router(context, text, child);
      break;
  }
}

void _router(BuildContext context, String text, Widget chd) {
  Navigator.of(context).push(
    PageRouteBuilder<Null>(
        pageBuilder: (context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Opacity(
                  opacity: animation.value,
                  child: Material(
                    child: chd,
                  ),
                );
              });
        },
        transitionDuration: Duration(milliseconds: 300)),
  );
}
