import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:maui/app.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/audio_text_bold.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:maui/quack/comment_text_field.dart';
import 'package:maui/quack/activity_drawing_grid.dart';
import 'package:maui/quack/header_app_bar.dart';
import 'package:maui/quack/text_audio.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';

class KnowledgeDetail extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;
  final bool showBackButton;

  KnowledgeDetail(
      {key, @required this.card, this.parentCardId, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DisplayStory(
      card: card,
      parentCardId: parentCardId,
      showBackButton: showBackButton,
    );
  }
}

class DisplayStory extends StatefulWidget {
  final QuackCard card;
  final String parentCardId;
  final bool showBackButton;

  DisplayStory(
      {key, @required this.card, this.parentCardId, this.showBackButton = true})
      : super(key: key);

  @override
  DisplayStoryState createState() {
    return new DisplayStoryState();
  }
}

class DisplayStoryState extends State<DisplayStory> {
  bool toggle = false;
  int duration = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return OrientationBuilder(
      builder: (context, orientation) => orientation == Orientation.portrait
          ? ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                LimitedBox(
                  maxHeight: media.size.height * 0.75,
                  child: CardHeader(
                    card: widget.card,
                    parentCardId: widget.parentCardId,
                    minHeight: media.padding.top,
                  ),
                ),
                AudioTextBold( card: widget.card)

                //=======================================
                // IconButton(
                //   icon: Icon(
                //     Icons.play_circle_filled,
                //     size: 50.0,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       toggle = !toggle;
                //     });
                //     print("you are pressing");
                //   },
                //   color: Colors.red,
                // ),
                //=====================================
                // widget.card.title == null
                //     ? Container()
                //     : Padding(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 16.0, horizontal: 8.0),
                //         child: Text(
                //           widget.card.title ?? '',
                //           style: Theme.of(context).textTheme.subhead,
                //         ),
                //       ),

                // audio playing with text done here
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: !toggle
                //       ? Text(widget.card.content ?? '')
                //       : TextAudio(
                //           audiofile: widget.card.contentAudio,
                //           fulltext: widget.card.content ?? '',
                //           duration: 10000,
                //         ),
                // )
                //===================================
              ],
            )
          : Row(
              children: <Widget>[
                widget.card.header == null
                    ? Container()
                    : Flexible(
                        flex: 1,
                        child: CardHeader(
                            card: widget.card,
                            parentCardId: widget.parentCardId)),
                Flexible(
                  flex: 1,
                  child: SafeArea(
                    child: ListView(
                      padding: EdgeInsets.all(8.0),
                      children: <Widget>[
                        AudioTextBold( card: widget.card)
                        // widget.card.title == null
                        //     ? Container()
                        //     : Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             vertical: 16.0, horizontal: 8.0),
                        //         child: Text(
                        //           widget.card.title ?? '',
                        //           style: Theme.of(context).textTheme.subhead,
                        //         ),
                        //       ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(widget.card.content ?? ''),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
