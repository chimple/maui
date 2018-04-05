import 'package:flutter/material.dart';
import '../components/orderable_stack.dart';
import '../components/orderable.dart';


class OrderIt extends StatelessWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  OrderIt({key, this.onScore, this.onProgress, this.onEnd, this.iteration}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
      return new MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

const kItemSize = const Size.square(80.0);
const kChars = const ["Monday", "Tuesday", "Wednesday", "Thursday","Friday","Saturday","Sunday"];

class _MyHomePageState extends State<MyHomePage> {
  List<String> chars = ["Monday", "Tuesday", "Wednesday", "Thursday","Friday","Saturday","Sunday"];

  ValueNotifier<String> orderNotifier = new ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    OrderPreview preview = new OrderPreview(orderNotifier: orderNotifier);
    Size gSize = MediaQuery.of(context).size;
        return new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ]),
              preview,
              new Center(
                  child:  new OrderableStack<String>(
                            direction: Direction.Vertical,
                            items: chars,
                            itemSize: const Size(200.0, 45.0),
                            itemBuilder: itemBuilder,
                            onChange: (List<String> orderedList) =>
                                orderNotifier.value = orderedList.toString()))
            ]);
  }

  Widget itemBuilder({Orderable<String> data, Size itemSize}) {
    return new Container(
      key: new Key("orderableDataWidget${data.dataIndex}"),
      color: data != null && !data.selected
          ? data.dataIndex == data.visibleIndex ? Colors.lime : Colors.cyan
          : Colors.orange,
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
