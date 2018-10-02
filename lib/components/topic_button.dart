import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/components/activity_progress_tracker.dart';
import 'package:maui/components/article_progress_tracker.dart';
import 'package:maui/components/quiz_progress_tracker.dart';

class TopicButton extends StatefulWidget {
  final String text;
  final int color;
  final String image;
  final VoidCallback onPress;
  final String topicId;
  final bool isDisplayingTopic;

  TopicButton({
    Key key,
    @required this.text,
    this.color,
    this.isDisplayingTopic = false,
    this.image,
    this.onPress,
    this.topicId,
//      this.sizeHieght,
//      this.sizeWidth
  }) : super(key: key);

  @override
  State createState() => new TopicButtonState();
}

class TopicButtonState extends State<TopicButton> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("hello Topic button ${widget.image} and ${widget.text}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Material(
        elevation: 8.0,
        color: Colors.brown,
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
        child: new InkWell(
          onTap: widget.onPress,
          child: new Column(
            children: <Widget>[
              new Expanded(
                  flex: 1,
                  child: new QuizProgressTracker(topicId: widget.topicId)),
              widget.isDisplayingTopic
                  ? new Expanded(
                      flex: 1,
                      child:
                          new ActivityProgressTracker(topicId: widget.topicId))
                  : new Container(),
               widget.isDisplayingTopic
                  ? new Expanded(
                      flex: 1,
                      child:
                          new ArticleProgressTracker(topicId: widget.topicId))
                  : new Container(),    
              widget.image == null
                  ? new Expanded(
                      flex: 12,
                      child: Container(color: Colors.red),
                    )
                  : widget.image.endsWith(".svg")
                      ? new Expanded(
                          flex: 12,
                          child: new Container(
                            color: Colors.red,
                            child: new AspectRatio(
                              aspectRatio: 2.0,
                              child: new SvgPicture.asset(
                                widget.image,
                                allowDrawingOutsideViewBox: false,
                              ),
                            ),
                          ),
                        )
                      : new Expanded(
                          flex: 12,
                          child: Container(
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: new AssetImage(widget.image),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.red),
                          ),
                        ),
              new Expanded(
                flex: 1,
                child: new Container(
                  child: new Center(
                    child: new Text(widget.text,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis),
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
