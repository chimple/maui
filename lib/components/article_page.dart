import 'package:maui/components/videoplayer.dart';
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
  var top = 0.0;

  @override
  void initState() {
    playerState = PlayerState.paused;
    articleProgressTracker();
    super.initState();
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

  BuildContext _ctx;
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;

    List<String> choices = [
      "Cat",
      "Sheep",
      "lion",
      "Cow" "shshs",
      "udsjhjd",
      "hdjajdh",
      "hello",
      "boss",
      "scroll"
    ];
    print("video and audio ${widget.video} and ${widget.audio}");
    return Scaffold(
      bottomNavigationBar: Container(
        height: top == 0.0 ? 100.0 : 100.0,
        child: new Material(
          color: Colors.orange,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
// controller: tabController,
//             tabs: <Widget>[
            children: [
              new Tab(
                child: new IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                    semanticLabel: "previous",
                  ),
                ),
              ),
//              new Tab(
//                child: Hud(
//                    user: widget.gameConfig.myUser,
//                    height: media.size.height / 8,
//                    gameMode: widget.gameMode,
//                    playTime: playTime,
//                    onEnd: widget.onGameEnd,
//                    progress:
//                    widget.gameConfig.amICurrentPlayer ? _myProgress : null,
//                    start: false,
//                    score: 10,
//                    backgroundColor: Colors.red,
//                    foregroundColor: Colors.blue),
//              ),
              new Tab(
                child: new Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
      body: new NotificationListener(
        onNotification: (v) {
          if (v is ScrollUpdateNotification) {
            setState(() => top -= v.scrollDelta / 4);
          }
        },
        child:
// Stack(children: [
//          new Positioned(
//            top: top,
//            child: new ConstrainedBox(
//              constraints: new BoxConstraints(maxHeight: 300.0),
//              child: new Image.asset('assets/images/pattern.jpg'),
//            ),
//          ),
            new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              titleSpacing: 0.0,
              elevation: 0.0,
              bottom: new PreferredSize(
                  child: Container(
                    // width: size.width,
                    height: size.height / 7,
                  ),
                  preferredSize: Size.fromHeight(
                    size.height / 7,
                  )),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              expandedHeight: size.height / 2,
              pinned: true,
              floating: false,
              // snap: true,

              flexibleSpace: new FlexibleSpaceBar(
                centerTitle: true,
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
//                        ? new Image.asset(
//                            "${widget.image}",
//                            fit: BoxFit.fitWidth,
////                        height: 500.0,
//                          )
//                        :
                    VideoApp(
                      gamename: "bingo",
                    ),

                    // This gradient ensures that the toolbar icons are distinct

                    // against the background image.

                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverList(
//              viewportFraction: 1.0,
              delegate: new SliverChildListDelegate(<Widget>[
                Container(
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(40.0)),
                    ),
                    child: Column(
                      children: [
//                        _Markdown(),
                        new MarkdownBody(
                          data: "${widget.text}",
                        ),
                        new MarkdownBody(data: "${widget.text}"),
                        new MarkdownBody(data: "${widget.text}"),
                        new MarkdownBody(data: "${widget.text}"),
                        new MarkdownBody(data: "${widget.text}"),
                        new MarkdownBody(data: "${widget.text}"),
                        new MarkdownBody(data: "${widget.text}"),
                      ],
                    )),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
