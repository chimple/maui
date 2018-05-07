import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import '../components/orderable_stack.dart';
import '../components/orderable.dart';
import '../repos/game_data.dart';

class OrderIt extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  OrderIt(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  // This widget is the root of your application.
  @override
  OrderItState createState() {
    return new OrderItState();
  }
}

class OrderItState extends State<OrderIt> {
  int _size = 12;
  int _maxSize = 4;
  List<String> _allLetters;
  List<String> _letters;
  bool _isLoading = true;
  int cnt = 0;
  int flag = 0;
  int temp = 0;
  @override
  void initState() {
    super.initState();
     print('OrderItState:initState');
     if (widget.gameConfig.level < 4) {
      _maxSize = 5;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 7;
    } else {
      _maxSize = 12;
    }
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _allLetters = await fetchSerialData(widget.gameConfig.gameCategoryId);
    print("Rajesh Patil Data ${_allLetters}");
    _letters = _allLetters.sublist(0, _maxSize);
    print("Rajesh Patil Sublisted Data ${_letters}");
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
    
   var hgt = 0.78*(1/_letters.length);

    OrderPreview preview = new OrderPreview(orderNotifier: orderNotifier);
    Size gSize = MediaQuery.of(context).size;
    print("Rajesh MediaQuery: ${gSize}");
    return new LayoutBuilder(builder: (context, constraints) {
      print(
          "Rajesh patil Width:${constraints.maxWidth} Height:${constraints.maxHeight}");
      return new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              preview,
                 new OrderableStack<String>(
                    direction: OrderItDirection.Vertical,
                    isRotated: widget.isRotated,
                    items: _letters,
                    itemSize: constraints.maxWidth > 410.0 && constraints.maxHeight > 570.0 
                      ? new Size(constraints.maxWidth * 0.4, constraints.maxHeight * hgt) 
                      : new Size(constraints.maxWidth * 0.4, constraints.maxHeight * hgt*0.8),  
                    itemBuilder: itemBuilder,
                    onChange: (List<String> orderedList) =>
                        orderNotifier.value = orderedList.toString()),
            ]),
      );
    });
  }
  Widget itemBuilder({Orderable<dynamic> data, Size itemSize}) {
    print("Rajesh Patil dataIndex: ${data.dataIndex}");
    print("Rajesh Patil selected: ${data.selected}");
    print("Rajesh Patil visibleIndex: ${data.visibleIndex}");
    print("Rajesh Patil value: ${data.value}");
    print("Rajesh Patil OrderPreview: ${orderNotifier.value}");
    print("Rajesh Patil flag: $flag");

    if ((orderNotifier.value.compareTo(_letters.toString()) == 0) && flag==0) {
      flag=1;
      new Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            widget.onScore(_maxSize);
            widget.onProgress(_maxSize/_letters.length);
            widget.onEnd();
          });
       });
    }
   
    return new Container(
      key: new Key("orderableDataWidget${data.dataIndex}"),
      decoration: new BoxDecoration(  
        boxShadow: [
          new BoxShadow(
          color: const Color(0x44000000),
          spreadRadius: 2.0,
          offset: const Offset(0.0, 1.0),
          )
        ],
       borderRadius: new BorderRadius.circular(12.0), 
       color: data != null && !data.selected ? data.dataIndex == data.visibleIndex ? Colors.lime : Colors.cyan : Colors.orange,
      ),
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
          child: new Column(children: [
        new Text(
          "${data.value}",
          style: new TextStyle(
              fontSize: itemSize.height * 0.7, color: Colors.white),
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
