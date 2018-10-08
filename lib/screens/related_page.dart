import 'package:flutter/material.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/components/topic_button.dart';
import 'package:maui/screens/topic_screen.dart';

class RelatedPage extends StatefulWidget {
  RelatedPage({Key key, @required this.topicId}) : super(key: key);
  final String topicId;
  @override
  _RelatedPageState createState() {
    return new _RelatedPageState();
  }
}

class _RelatedPageState extends State<RelatedPage> {
  List<Card> topic = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    topic = await CollectionRepo()
        .getCardsInCollectionByType(widget.topicId, CardType.collection);
    setState(() => _isLoading = false);
  }

  Widget _buildTile(int index) {
    // print('topic tile ${topic[index].id} $index ${topic[index]}');
    return new TopicButton(
        text: topic[index].name,
        color: topic[index].color,
        image: topic[index].image,
        onPress: () => Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new TopicScreen(
                        topicId: topic[index].id,
                        topicName: topic[index].name,
                        topicImage: topic[index].image,
                      )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    //   MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new Scaffold(
        body: new Container(
            color: const Color(0xffFECE3D),
            child: new GridView.count(
                primary: true,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                crossAxisCount: 2,
                children:
                    new List.generate(topic.length, (i) => _buildTile(i)))));
  }
}
