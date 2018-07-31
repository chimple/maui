import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  final String articleId;
  final String name;
  final String topicId;
  final String video;
  final String audio;
  final String image;
  final String text;
  final int order;

  ArticlePage({
    Key key,
    @required this.articleId,
    @required this.name,
    @required this.topicId,
    @required this.video,
    @required this.audio,
    @required this.image,
    @required this.text,
    @required this.order,
  }) : super(key: key);

  @override
  _ArticlePageState createState() {
    return new _ArticlePageState();
  }
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      print("Screen Size: ${constraints.maxHeight} , ${constraints.maxWidth}");
      return Material(
        type: MaterialType.transparency,
        child: new Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
          ),
          child: new Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: new Container(
                  width: constraints.maxWidth * 0.992,
                  height: constraints.maxHeight * 0.732,
                  color: Colors.red,
                  child: FittedBox(
                    child: new Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child: new Text("Progress Indicator"),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(left: 230.0),
                        color: Colors.blue,
                        child: IconButton(
                          iconSize: 40.0,
                          alignment: AlignmentDirectional.bottomStart,
                          icon: Icon(Icons.audiotrack, color: Colors.black),
                          onPressed: () {
                            //Call Audio To Play
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: new Container(
                  width: 500.0,
                  height: 126.0,
                  color: Colors.grey,
                  child: new Markdown(
                    data: widget.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
