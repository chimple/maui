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
  TopicCardView({key, @required this.topicId}) : super(key: key);
  @override
  _TopicCardViewState createState() => new _TopicCardViewState();
}

class _TopicCardViewState extends State<TopicCardView> {
  List<Article> _articles;
  List<Activity> _activities;
  List<Topic> _topics;
  List<Quiz> _quizzes;
  bool _isDataAvailable = false;
//  bool _isForwardDisable = false;
//  bool _isBackwardDisable = true;

  PageController pageController = new PageController(initialPage: 0);

  void _initArticles() async {
    _articles = await ArticleRepo().getArticlesByTopicId(widget.topicId);
    _activities = await ActivityRepo().getActivitiesByTopicId(widget.topicId);
    _topics =
        await RelatedTopicRepo().getTopicsByRelatedTopicId(widget.topicId);
    _quizzes = await QuizRepo().getQuizzesByTopicId(widget.topicId);
    setState(() {
      _isDataAvailable = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initArticles();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return SliverGrid.count(
      crossAxisCount: media.size.height > media.size.width ? 3 : 4,
      childAspectRatio: 0.8,
      children: _isDataAvailable
          ? [_activities, _articles, _topics, _quizzes]
              .expand((l) => l.map((o) {
                    if (o is Activity) {
                      Activity a = o as Activity;
                      return CardButton(
                        text: a.text,
                        image: a.image,
                        id: a.id,
                        topicId: widget.topicId,
                        cardType: CardType.activity,
                      );
                    } else if (o is Article) {
                      Article a = o as Article;
                      return CardButton(
                        text: a.name,
                        image: a.image,
                        id: a.id,
                        topicId: widget.topicId,
                        cardType: CardType.article,
                      );
                    } else if (o is Topic) {
                      Topic a = o as Topic;
                      return CardButton(
                        text: a.name,
                        image: a.image,
                        id: a.id,
                        topicId: widget.topicId,
                        cardType: CardType.topic,
                      );
                    } else if (o is Quiz) {
                      Quiz a = o as Quiz;
                      return CardButton(
                        text: "Quiz",
                        image: 'assets/background_image/quiz_small.png',
                        id: a.id,
                        topicId: widget.topicId,
                        cardType: CardType.quiz,
                      );
                    }
                  }))
              .toList(growable: false)
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
