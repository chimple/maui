import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/activity/jumble_words.dart';

class CoverPage extends StatelessWidget {
  final String coverImagePath;
  final String conveImageDescription;
  CoverPage({this.coverImagePath, this.conveImageDescription});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          AssetImage('assets/stories/images/${coverImagePath}'),
                    )),
              )),
          Expanded(
            flex: 6,
            child: Container(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    conveImageDescription ?? "Credit: Ram Kumar Bhadoria",
                    style: textStyle(fSize: 20),
                  ),
                  Text(
                    conveImageDescription ?? "Writer: Ram Kumar Bhadoria",
                    style: textStyle(fSize: 20),
                  )
                ],
              ),
            )),
          ),
        ],
      );
}
