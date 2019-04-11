import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:data/data.dart';
import 'package:maui/jamaica/widgets/story/audio_text_bold.dart';
import 'package:maui/jamaica/widgets/story/cover_page.dart';
import 'package:maui/jamaica/widgets/story/play_pause_button.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';

class StoryPage extends StatefulWidget {
  final BuiltList<Page> pages;
  final String title;
  final String coverImagePath;
  StoryPage({Key key, @required this.pages, this.title, this.coverImagePath})
      : super(key: key);

  @override
  StoryPageState createState() {
    return new StoryPageState();
  }
}

class StoryPageState extends State<StoryPage> {
  bool _isPlaying = false;
  PageController pageController = PageController();
  List<StoryMode> _storyMode = [];
  ScrollController _controller;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pages.length; i++)
      _storyMode.add(StoryMode.textMode);
    _controller = new ScrollController();
    _controller.addListener(() {
      print('sadsdsa ${_controller.position}');
    });
    print('_sdsad ${_controller.initialScrollOffset}');
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    widgets.add(CoverPage(
      coverImagePath: widget.coverImagePath,
    ));
    widget.pages.map((data) {
      widgets.add(AudioTextBold(
        imagePath: data.imagePath,
        audioFile: data.audioPath,
        fullText: data.text,
//              imageItemsAnswer: widget.pages[index].imageItemsAnswer,
        pageNumber: data.pageNumber,
        // storyMode: _storyMode[index],
        // index: index,
      ));
    }).toList();
    return new Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   backgroundColor: Colors.orange,
      //   centerTitle: true,
      // ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 90,
            child: Container(
              color: Colors.orange,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () => Navigator.of(context).pop()),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white, width: 2.0)),
                    child: Row(
                      children: <Widget>[
                        Text("15",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Icon(Icons.star, color: Colors.yellow)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              // constraints: BoxConstraints.expand(),
              child: Scrollbar(
                child: SingleChildScrollView(
                    controller: _controller,
                    scrollDirection: Axis.vertical,
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: widgets,
//                              widget.pages.map((data) {
//                           return AudioTextBold(
//                             imagePath: data.imagePath,
//                             audioFile: data.audioPath,
//                             fullText: data.text,
// //              imageItemsAnswer: widget.pages[index].imageItemsAnswer,
//                             pageNumber: data.pageNumber,
//                             // storyMode: _storyMode[index],
//                             // index: index,
//                           );
//                           // return Column(
//                           //   children: <Widget>[
//                           //     SizedBox(
//                           //         height:
//                           //             MediaQuery.of(context).size.height * .3,
//                           //         child: Container(
//                           //           decoration: BoxDecoration(
//                           //               borderRadius:
//                           //                   BorderRadius.circular(20.0),
//                           //               image: DecorationImage(
//                           //                 fit: BoxFit.cover,
//                           //                 image: AssetImage(
//                           //                     'assets/stories/images/${data.imagePath}'),
//                           //               )),
//                           //         )),
//                           //     SizedBox(
//                           //       height: MediaQuery.of(context).size.height * .6,
//                           //       child: Container(
//                           //         child: Text(
//                           //           data.text,
//                           //           style: TextStyle(fontSize: 20),
//                           //         ),
//                           //       ),
//                           //     )
//                           //   ],
//                           // );
//                         }).toList(growable: false)
                        ))),
              ),
            ),
//             child: PageView.builder(
//               pageSnapping: false,
//               controller: pageController,
//               onPageChanged: (int index) {
//                 print(index);
//               },
//               scrollDirection: Axis.vertical,
//               physics:
//                   _isPlaying ? NeverScrollableScrollPhysics() : ScrollPhysics(),
//               itemBuilder: (context, index) {
// //          var d = widget.pages[index].imageItemsPosition;
// //          print('drag data :: ${d}');
// //          print('data:: ${widget.pages[index].highlightQuestion}');
//                 if (index == 0)
//                   return CoverPage(
//                     coverImagePath: widget.coverImagePath,
//                   );
//                 else {
//                   index = index - 1;
//                   return AudioTextBold(
//                       imagePath: widget.pages[index].imagePath,
//                       audioFile: widget.pages[index].audioPath,
//                       fullText: widget.pages[index].text,
// //              imageItemsAnswer: widget.pages[index].imageItemsAnswer,
//                       pageNumber: widget.pages[index].pageNumber,
//                       storyMode: _storyMode[index],
//                       index: index,
//                       storyModeCallback: (index, StoryMode sm) => setState(
//                             () => _storyMode[index] = sm,
//                           ),
//                       pageSliding: () => setState(() {
//                             _isPlaying = !_isPlaying;
//                             // pageController.jumpToPage(
//                             //     int.parse(widget.pages[index].pageNumber) - 1);
//                           }));
//                 }
//               },
//               itemCount: widget.pages.length + 1,
//             ),
          )
        ],
      ),
    );
  }
}
