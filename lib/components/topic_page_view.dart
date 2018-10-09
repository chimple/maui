import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/components/article_page.dart';

class TopicPageView extends StatefulWidget {
  final String topicId;
  TopicPageView({key, @required this.topicId}) : super(key: key);
  @override
  _TopicPageViewState createState() => new _TopicPageViewState();
}

class _TopicPageViewState extends State<TopicPageView> {
  List<QuackCard> _articles;
  bool _isDataAvailable = false;
//  bool _isForwardDisable = false;
//  bool _isBackwardDisable = true;

  PageController pageController = new PageController(initialPage: 0);

  void _initArticles() async {
    await new CollectionRepo()
        .getCardsInCollectionByType(widget.topicId, CardType.knowledge)
        .then((articles) async {
      setState(() {
        _articles = articles;
        _articles.length != 0
            ? _isDataAvailable = true
            : _isDataAvailable = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initArticles();
  }
//  _forwardButtonBehaviour(forward) {
//    pageController.nextPage(
//        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
//    if (pageController.page == 0.0) {
//      setState(() {
//        _isBackwardDisable = false;
//      });
//    }
//    if ((pageController.page + 1.0).toInt() == (_articles.length - 1)) {
//      setState(() {
//        _isForwardDisable = true;
//      });
//    }
//  }
//
//  void _backwardButtonBehaviour(bool backward) {
//    pageController.previousPage(
//        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
//    if ((pageController.page).toInt() == (_articles.length - 1)) {
//      setState(() {
//        _isForwardDisable = false;
//      });
//    }
//    if (pageController.page - 1.0 == 0.0) {
//      setState(() {
//        _isBackwardDisable = true;
//      });
//    }
//  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isDataAvailable == false
        ? new Container(
            child: new Center(
              child: new Text(
                Loca.of(context).no_data,
                style:
                    new TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : new Stack(
            children: <Widget>[
              new PageView.builder(
                pageSnapping: false,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _articles.length,
                controller: pageController,
                itemBuilder: (context, index) {
                  return new ArticlePage(
                    articleId: _articles[index].id,
                    name: _articles[index].title,
                    text: _articles[index].content,
                    audio: _articles[index].contentAudio,
                    header: _articles[index].header,
                    page: pageController,
                  );
                },
              ),
            ],
          );
  }
}
