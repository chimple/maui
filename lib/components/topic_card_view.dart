import 'package:flutter/material.dart';
import 'package:maui/components/card_button.dart';
import 'package:maui/components/topic_button.dart';
import 'package:maui/db/entity/activity.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/db/entity/topic.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/activity_repo.dart';
import 'package:maui/repos/article_repo.dart';
import 'package:maui/db/entity/article.dart';
import 'package:maui/components/article_page.dart';
import 'package:maui/repos/quiz_repo.dart';
import 'package:maui/repos/related_topic_repo.dart';

class TopicCardView extends StatefulWidget {
  final String topicId;
  final CardType cardType;

  TopicCardView({key, @required this.topicId, @required this.cardType})
      : super(key: key);
  @override
  _TopicCardViewState createState() => new _TopicCardViewState();
}

class _TopicCardViewState extends State<TopicCardView> {
  List<Article> _articles;
  List<Activity> _activities;
  List<Topic> _topics;
  List<Quiz> _quizzes;
  bool _isDataAvailable = false;

  void _initArticles() async {
    switch (widget.cardType) {
      case CardType.activity:
        _activities =
            await ActivityRepo().getActivitiesByTopicId(widget.topicId);
        break;
      case CardType.article:
        _articles = await ArticleRepo().getArticlesByTopicId(widget.topicId);
        break;
      case CardType.topic:
        _topics =
            await RelatedTopicRepo().getTopicsByRelatedTopicId(widget.topicId);
        print('main: $_topics');
        break;
      case CardType.quiz:
        _quizzes = await QuizRepo().getQuizzesByTopicId(widget.topicId);
    }
    setState(() {
      _isDataAvailable = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initArticles();
  }

  List<Widget> _buildList() {
    switch (widget.cardType) {
      case CardType.activity:
        return _activities
            .map((a) => CardButton(
                  text: a.text,
                  image: a.image,
                  id: a.id,
                  topicId: widget.topicId,
                  cardType: CardType.activity,
                ))
            .toList(growable: false);
        break;
      case CardType.article:
        return _articles
            .map((a) => CardButton(
                  text: a.name,
                  image: a.image,
                  id: a.id,
                  topicId: widget.topicId,
                  cardType: CardType.article,
                ))
            .toList(growable: false);
        break;
      case CardType.topic:
        return _topics
            .map((a) => CardButton(
                  text: a.name,
                  image: a.image,
                  id: a.id,
                  topicId: widget.topicId,
                  cardType: CardType.topic,
                ))
            .toList(growable: false);
        break;
      case CardType.quiz:
        return _quizzes
            .map((a) => CardButton(
                  text: "Quiz",
                  image: 'assets/background_image/quiz_small.png',
                  id: a.id,
                  topicId: widget.topicId,
                  cardType: CardType.quiz,
                ))
            .toList(growable: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return SliverGrid.count(
      crossAxisCount: media.size.height > media.size.width ? 3 : 4,
      childAspectRatio: 0.8,
      children: _isDataAvailable
          ? _buildList()
          : <Widget>[
              Container(
                child: new Center(
                  child: new Text(
                    Loca.of(context).no_data,
                    style: new TextStyle(
                        fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
    );
  }
}
