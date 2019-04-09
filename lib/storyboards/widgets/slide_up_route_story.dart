import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maui/jamaica/widgets/slide_up_route.dart';
import 'package:storyboard/storyboard.dart';

class SlideUpRouteStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        _FirstScreen(),
      ];
}

class _FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: RaisedButton(
          child: Text('Go To Next Page'),
          onPressed: () => Navigator.push(
                context,
                SlideUpRoute(widgetBuilder: (context) => _SecondScreen()),
              ),
        ),
      ),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Go To Next Page'),
              onPressed: () => Navigator.push(
                    context,
                    SlideUpRoute(widgetBuilder: (context) => _ThirdScreen()),
                  ),
            ),
            RaisedButton(
              child: Text('Go Back'),
              onPressed: () => Navigator.pop(
                    context,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: RaisedButton(
          child: Text('Go Back'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
