import 'dart:async';

import 'package:flutter/material.dart';
import '../components/orderable_stack.dart';
import '../components/orderable.dart';
import '../repos/game_data.dart';

class OrderIt extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;
  int gameCategoryId;

  OrderIt({key, this.onScore, this.onProgress, this.onEnd, this.iteration, this.gameCategoryId, this.isRotated = false}) : super(key: key);

  // This widget is the root of your application.
  @override
  OrderItState createState() {
    return new OrderItState();
  }
}

//const kItemSize = const Size.square(80.0);
//const kChars = const ["A", "B", "C", "D"];

class OrderItState extends State<OrderIt> {
  List<String> _chars = ["A", "B", "C", "D","E","F","G"];
  int _size = 7;
  List<String> _allLetters;
  List<String> _letters;
  bool _isLoading = true;
  int cnt = 0;
  
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
   _allLetters = await fetchSerialData(widget.gameCategoryId); 
    print("Rajesh Patil Data ${_allLetters}");
   _letters = _allLetters.sublist(0, _size );
    print("Rajesh Patil Sublisted Data ${_letters}");
    print("Rajesh Patil HardCoded Data ${_chars}");
    setState(() => _isLoading = false);
  }

  ValueNotifier<String> orderNotifier = new ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    print("OrderItState.build");
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    OrderPreview preview = new OrderPreview(orderNotifier: orderNotifier);
    Size gSize = MediaQuery.of(context).size;
    print("Rajesh MediaQuery: ${gSize}");
        return new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ]),
              preview,
              new Center(
                  child:  new OrderableStack<String>(
                            direction: OrderItDirection.Vertical,
                            isRotated: widget.isRotated,
                            items: _letters,
                            itemSize: const Size(200.0, 50.0),
                            itemBuilder: itemBuilder,
                            onChange: (List<String> orderedList) =>
                                orderNotifier.value = orderedList.toString()))
            ]);
  }

  Widget itemBuilder({Orderable<String> data, Size itemSize}) {
    print("Rajesh Patil dataIndex: ${data.dataIndex}");
    print("Rajesh Patil selected: ${data.selected}");
    print("Rajesh Patil visibleIndex: ${data.visibleIndex}");
    print("Rajesh Patil value: ${data.value}");
    print("Rajesh Patil OrderPreview: ${orderNotifier.value}");

    if(orderNotifier.value.compareTo(_letters.toString()) == 0)
    {
      print("Game Over!!: ${cnt++}");
      new Future.delayed(const Duration(milliseconds: 100), () {    
               // setState(() {
                  // widget.onScore(7);
                  // widget.onProgress(1.0);
                   widget.onEnd();
                      // });
                });
    }

    return new Container(
      key: new Key("orderableDataWidget${data.dataIndex}"),
      color: data != null && !data.selected ? data.dataIndex == data.visibleIndex ? Colors.lime : Colors.cyan : Colors.orange,
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
          child: new Column(children: [
        new Text(
          "${data.value}",
          style: new TextStyle(fontSize: 25.0, color: Colors.white),
        )
      ])),
    ); 
  }
}

class OrderPreview extends StatefulWidget {
  final ValueNotifier orderNotifier;
  
  OrderPreview({this.orderNotifier});

  @override
  State<StatefulWidget> createState() => new OrderPreviewState();
}

class OrderPreviewState extends State<OrderPreview> {
  String data = '';

  OrderPreviewState();

  @override
  void initState() {
    super.initState();
    widget.orderNotifier
        .addListener(() => setState(() => data = widget.orderNotifier.value));
  }

  @override
  Widget build(BuildContext context) => new Text(" ");
}
