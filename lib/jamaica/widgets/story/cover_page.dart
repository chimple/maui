import 'package:flutter/material.dart';

class CoverPage extends StatelessWidget {
  final String coverImagePath;
  final String conveImageDescription;
  CoverPage({this.coverImagePath, this.conveImageDescription});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * .4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/stories/images/${coverImagePath}',
                ),
              )),
        ),
        Container(
            height: MediaQuery.of(context).size.height * .7,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Text(conveImageDescription ?? "Credit: Ram Kumar Bhadoria"),
                  Text(conveImageDescription ?? "Credit: Ram Kumar Bhadoria")
                ],
              ),
            )),
      ],
    );
  }
}
