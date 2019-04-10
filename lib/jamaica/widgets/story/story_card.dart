import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:maui/jamaica/widgets/story/router.dart';
import 'package:maui/jamaica/widgets/story/story_page.dart';

class StoryCard extends StatelessWidget {
  final index;
  final StoryConfig storyConfig;
  StoryCard({this.index, @required this.storyConfig});
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Padding(
        padding: EdgeInsets.all(constraint.maxHeight * .06),
        child: Stack(
          children: <Widget>[
            Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(constraint.maxHeight * .16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(constraint.maxHeight * .16),
                              topRight:
                                  Radius.circular(constraint.maxHeight * .16)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/stories/images/${storyConfig.coverImagePath}'))),
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        storyConfig.title,
                        style: TextStyle(fontSize: constraint.maxHeight * .1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
            FlatButton(
              splashColor: Colors.black26,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(constraint.maxHeight * .16)),
              child: Container(),
              // enableFeedback: true,
              // excludeFromSemantics: true,
              // splashColor: Colors.red,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => StoryPage(
                      pages: storyConfig.pages, title: storyConfig.title),
                ));
              },
            )
          ],
        ),
      );
    });
  }
}
