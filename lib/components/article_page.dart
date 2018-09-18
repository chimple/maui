import 'dart:async';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/article_progress_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum PlayerState { playing, paused, stopped }

class ArticlePage extends StatefulWidget {
  final String articleId;
  final String name;
  final String topicId;
  final String video;
  final String audio;
  final String image;
  final String text;
  final int serial;

  ArticlePage({
    Key key,
    @required this.articleId,
    @required this.name,
    @required this.topicId,
    @required this.video,
    @required this.audio,
    @required this.image,
    @required this.text,
    @required this.serial,
  }) : super(key: key);

  @override
  _ArticlePageState createState() {
    return new _ArticlePageState();
  }
}

class _ArticlePageState extends State<ArticlePage> {
  PlayerState playerState;
  User user;

  @override
  void initState() {
    playerState = PlayerState.paused;
    articleProgressTracker();
    super.initState();
  }

  void articleProgressTracker() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var timeStampId = new DateTime.now().millisecondsSinceEpoch.toString();
      user = AppStateContainer.of(context).state.loggedInUser;
      await ArticleProgressRepo().insertArticleProgress(Uuid().v4(),
          user.id, widget.topicId, widget.articleId, timeStampId);
    });
  }

  void onComplete() {
    print('onComplete CallBack:');
    setState(() => playerState = PlayerState.paused);
  }

  @override
  void deactivate() {
    AppStateContainer.of(_ctx).stopArticleAudio();
    super.deactivate();
  }

  BuildContext _ctx;
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return new LayoutBuilder(builder: (context, constraints) {
      print("Size ${constraints.maxHeight} , ${constraints.maxWidth}");
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
              widget.audio != null
                  ? Expanded(
                      flex: 1,
                      child: new RawMaterialButton(
                        shape: new CircleBorder(),
                        fillColor: Colors.white,
                        splashColor: Colors.teal,
                        highlightColor: Colors.teal.withOpacity(0.5),
                        elevation: 10.0,
                        highlightElevation: 5.0,
                        onPressed: () {
                          if (playerState == PlayerState.stopped ||
                              playerState == PlayerState.playing) {
                            AppStateContainer.of(context).pauseArticleAudio();
                            setState(() {
                              playerState = PlayerState.paused;
                            });
                          } else {
                            AppStateContainer.of(context)
                                .playArticleAudio(widget.audio, onComplete);
                            setState(() {
                              playerState = PlayerState.playing;
                            });
                          }
                        },
                        child: new Icon(
                          (playerState == PlayerState.stopped ||
                                  playerState == PlayerState.playing)
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.purple,
                          size: 40.0,
                        ),
                      ),
                    )
                  : new Container(),
              Expanded(
                flex: 3,
                child: new Container(
                    color: Colors.grey,
                    child: new Markdown(
                      data: widget.text,
                    )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
