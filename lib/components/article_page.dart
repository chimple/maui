import 'dart:async';

import 'package:maui/components/topic_page_view.dart';
import 'package:maui/components/videoplayer.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/article_progress_repo.dart';
import 'package:maui/screens/topic_screen.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui' as ui;

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
  PageController page;

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
    this.page,
  }) : super(key: key);

  @override
  _ArticlePageState createState() {
    return new _ArticlePageState();
  }
}

class _ArticlePageState extends State<ArticlePage>
    with SingleTickerProviderStateMixin {
  PlayerState playerState;
  VideoPlayerController _controller;
  bool _isPlaying = false;
  var expheight;
  TabController tabController;

  User user;
  bool _isLoading = true;
  bool showBottomBar = true;
  bool _afterPress = false;
  var top = 0.0;

  @override
  void initState() {
    playerState = PlayerState.paused;
    //articleProgressTracker();
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    _isLoading = false;
    _controller = VideoPlayerController.asset("assets/demo_video/video.mp4")
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
            _afterPress = true;
          });
        }
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
//          _controller.pause();
        });
      });
  }

  _forwardButtonBehaviour() {
    widget.page.nextPage(
        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void _backwardButtonBehaviour() {
    widget.page.previousPage(
        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void articleProgressTracker() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = AppStateContainer.of(context).state.loggedInUser;
      await ArticleProgressRepo().insertArticleProgress(
          Uuid().v4(), user.id, widget.topicId, widget.articleId);
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

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    tabController.dispose();
    super.dispose();
  }

  var _scrollController =
      new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  Future<ui.Image> _getImage() {
    Image image = new Image.asset('assets/dict/cat.png');
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image.resolve(new ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(info.image));
    return completer.future;
  }

  BuildContext _ctx;
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    return Scaffold(
        bottomNavigationBar: Container(
          height: showBottomBar ? size.height * 0.1 : 0.0,
          child: new Material(
            color: Colors.orange,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Tab(
                    child: new IconButton(
                      onPressed: () => _backwardButtonBehaviour(),
                      icon: new Icon(
                        Icons.arrow_back,
                        size: 70.0,
                        semanticLabel: "previous",
                      ),
                    ),
                  ),
                ),
                widget.audio != null
                    ? new RawMaterialButton(
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
//                              _controller.pause();
                            });
                          } else {
                            AppStateContainer.of(context)
                                .playArticleAudio(widget.audio, onComplete);
                            setState(() {
                              playerState = PlayerState.playing;
                              _controller.pause();
                            });
                          }
                        },
                        child: new Icon(
                          (playerState == PlayerState.stopped ||
                                  playerState == PlayerState.playing)
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.purple,
                          size: 70.0,
                        ),
                      )
                    : new Container(),
                // tab audio
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Tab(
                    child: new IconButton(
                      onPressed: () => _forwardButtonBehaviour(),
                      icon: new Icon(
                        Icons.arrow_forward,
                        semanticLabel: "previous",
                        size: 70.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: new FutureBuilder<ui.Image>(
          future: _getImage(),
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              ui.Image image = snapshot.data;

              expheight = image.height;

              return new NotificationListener(
                onNotification: (v) {
                  if (v is ScrollUpdateNotification) {
                    print("top is her ${_scrollController.offset} ");
                    print("top is her ${size.height / 2.5} ");
                    if (_afterPress == true) {
                      if (_scrollController.offset >= size.height / 2.5) {
                        setState(() {
                          _controller.pause();
                        });
                      }
                      if (_scrollController.offset == 0.0) {
                        setState(() {
                          _controller.play();
                          AppStateContainer.of(context).pauseArticleAudio();
                          setState(() {
                            playerState = PlayerState.paused;
                          });
                        });
                      }
                    }
                  }
                },
                child: new CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    new SliverAppBar(
                      titleSpacing: 0.0,
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      expandedHeight: size.height / 2,
                      pinned: false,
                      floating: true,
                      // snap: true,

                      flexibleSpace: new FlexibleSpaceBar(
                        centerTitle: true,
                        background: new Column(
                          children: <Widget>[
                            widget.video == null
                                ? new Image.asset(
                                    "${widget.image}",
                                    fit: BoxFit.fitWidth,
                                  )
                                : Expanded(
                                    child: Stack(children: [
                                      Container(
                                        height: media.size.height,
                                        width: media.size.width,
                                        color: Colors.white,
                                      ),
                                      GestureDetector(
                                        onTap: _controller.value.isPlaying
                                            ? _controller.pause
                                            : _controller.play,
                                        child: Center(
                                          child: _controller.value.initialized
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Center(
                                                    child: Container(
                                                      height:
                                                          media.size.height / 2,
                                                      width: media.size.width /
                                                          1.5,
                                                      child: AspectRatio(
                                                        aspectRatio: 16 / 9,
                                                        child: VideoPlayer(
                                                            _controller),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Center(
                                                    child: Container(
                                                        height:
                                                            media.size.height /
                                                                2,
                                                        width:
                                                            media.size.width /
                                                                1.5,
                                                        child: VideoPlayer(
                                                            _controller)),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _controller.value.isPlaying
                                            ? _controller.pause
                                            : _controller.play,
                                        child: Center(
                                          child: new Container(
                                            height: 60.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: new Center(
                                              child: Icon(
                                                _controller.value.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                                size: 100.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.0, -1.0),
                                  end: Alignment(0.0, -0.4),
                                  colors: <Color>[
                                    Color(0x60000000),
                                    Color(0x00000000)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new SliverList(
                      delegate: new SliverChildListDelegate(<Widget>[
                        Container(
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(30.0),
                                  topRight: const Radius.circular(40.0)),
                            ),
                            child: MarkdownBody(
                              data: "${widget.text}",
                              onTapLink: (e) => Navigator.of(_ctx)
                                  .pushReplacement(new MaterialPageRoute(
                                      builder: (BuildContext _ctx) =>
                                          new TopicScreen(
                                            topicId: "fox",
                                            topicName: "fox",
                                          ))),
                            )),
                      ]),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
